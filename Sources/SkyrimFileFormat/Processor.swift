// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

protocol ProcessorProtocol {
    associatedtype BaseIterator: AsyncIteratorProtocol where BaseIterator.Element == Byte
    typealias Iterator = AsyncBufferedIterator<BaseIterator>
    var processor: Processor { get }
}

extension ProcessorProtocol {
    var configuration: Configuration { processor.configuration }
}

protocol RecordDataIterator: AsyncIteratorProtocol where Element == RecordData {
}

class Processor {
    internal init(configuration: Configuration = .defaultConfiguration) {
        self.configuration = configuration
        self.jsonEncoder = JSONEncoder()
        self.jsonDecoder = JSONDecoder()
        self.binaryEncoder = BinaryEncoder()

        jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }
    
    let configuration: Configuration
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder
    let binaryEncoder: BinaryEncoder
    
    func recordData<I: AsyncByteSequence>(bytes: I) -> AsyncThrowingIteratorMapSequence<I, RecordData> {
        let records = bytes.iteratorMap { iterator -> RecordData in
            let stream = AsyncDataStream(iterator: iterator)
            let type = try await Tag(stream.read(UInt32.self))
            let size = try await stream.read(UInt32.self)
            let header = try await RecordHeader(type: type, stream)
            let payloadSize = Int(type == GroupRecord.tag ? size - 24 : size)
            let data = LoadedRecordData(data: try await stream.read(count: payloadSize))
            iterator = stream.iterator

            return try await RecordData(type: type, header: header, data: data)
        }

        return records
    }

    func records<I: AsyncByteSequence>(bytes: I, processChildren: Bool) -> AsyncThrowingMapSequence<AsyncThrowingIteratorMapSequence<I, RecordData>, RecordProtocol> {
        let wrapped = recordData(bytes: bytes).map { recordData in
            try await self.record(from: recordData, processChildren: processChildren)
        }
        
        return wrapped
    }

    func record(from record: RecordData, processChildren: Bool) async throws -> RecordProtocol {
        if record.isGroup {
            var children: [RecordProtocol] = []
            if processChildren {
                for try await child in recordData(bytes: record.data.asyncBytes) {
                    children.append(try await self.record(from: child, processChildren: processChildren))
                }
            }
            
            return GroupRecord(header: record.header, children: children)
        } else {
            let fields = try await decodedFields(type: record.type, header: record.header, data: record.data)
            let recordClass = configuration.recordClass(for: record.type)
            let decoder = RecordDecoder(header: record.header, fields: fields)
            return try recordClass.init(from: decoder)
        }
    }
    
    func fields<I>(bytes: inout I, types: FieldTypeMap, inRecord recordType: Tag, withHeader recordHeader: RecordHeader) -> AsyncThrowingIteratorMapSequence<I, Field> where I: AsyncSequence, I.Element == Byte {
        let sequence = bytes.iteratorMap { iterator -> Field in
            let header = try await Field.Header(&iterator)
            let data = try await iterator.next(bytes: Bytes.self, count: Int(header.size))
            return try await self.inflate(header: header, data: data, types: types, inRecord: recordType, withHeader: recordHeader)
        }
        
        return sequence
    }
    
    func decodedFields(type: Tag, header: RecordHeader, data: RecordDataProvider) async throws -> DecodedFields {
        let map = try configuration.fields(forRecord: type)
        let fp = DecodedFields(map, for: type, header: header)
        
        var bytes = data.asyncBytes
        
        let fields = fields(bytes: &bytes, types: map, inRecord: type, withHeader: header)
        for try await field in fields {
            try fp.add(field)
        }
        fp.moveUnprocesed()
        
        return fp
    }
    
    func inflate(header: Field.Header, data: Bytes, types: FieldTypeMap, inRecord recordType: Tag, withHeader recordHeader: RecordHeader) async throws -> Field {
        do {
            if let type = types.fieldType(forTag: header.type) {
                let decoder = FieldDecoder(header: header, data: data, inRecord: recordType, withHeader: recordHeader)
                let unpacked = try type.init(fromBinary: decoder)
                return Field(header: header, value: unpacked)
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic field.\n\n\(error)")
        }
        
        return Field(header: header, value: data)
    }

    
    func pack<I: AsyncByteSequence>(bytes: I, to url: URL) async throws {
        let records = recordData(bytes: bytes)
        var index = 0
        for try await record in records {
            do {
                if record.isGroup {
                    try await export(group: record, index: index, asJSONTo: url)
                } else {
                    try await export(record: record, index: index, asJSONTo: url)
                }
            } catch {
                print(error)
            }
            index += 1
        }
    }

    
    func export(record rawRecord: RecordData, index: Int, asJSONTo url: URL) async throws {
        let header = rawRecord.header
        let fields = try await decodedFields(type: rawRecord.type, header: rawRecord.header, data: rawRecord.data)
        let recordClass = configuration.records[rawRecord.type] ?? RawRecord.self

        let decoder = RecordDecoder(header: header, fields: fields)
        let record = try recordClass.init(from: decoder)
        
        var label = rawRecord.name
        if let identified = record as? IdentifiedRecord {
            label = "\(identified.editorID) \(label)"
        }

        let name = String(format: "%04d %@", index, label)
        let recordURL = url.appendingPathComponent(name)

        let encoded = try record.asJSON(with: self)
        try encoded.write(to: recordURL.appendingPathExtension("json"), options: .atomic)
    }
    
    
    func export(group: RecordData, index: Int, asJSONTo url: URL) async throws {
        let name = String(format: "%04d %@", index, group.name)
        let groupURL = url.appendingPathComponent(name).appendingPathExtension(GroupRecord.fileExtension)

        try FileManager.default.createDirectory(at: groupURL, withIntermediateDirectories: true)

        let header = group.header
        let headerURL = groupURL.appendingPathComponent("header.json")
        let encoded = try jsonEncoder.encode(header)
        try encoded.write(to: headerURL, options: .atomic)

        let childrenURL = groupURL.appendingPathComponent("records")
        try FileManager.default.createDirectory(at: childrenURL, withIntermediateDirectories: true)

        try await pack(bytes: group.data.asyncBytes, to: childrenURL)
    }
    
    func save(_ records: [RecordProtocol]) throws -> Data {
        let binaryEncoder = BinaryEncoder()
        for record in records {
            let type = type(of: record).tag
            let fields = try configuration.fields(forRecord: type)
            let recordEncoder = RecordEncoder(fields: fields)
            try record.encode(to: recordEncoder)
            let encoded = recordEncoder.binaryEncoder.data

            try type.binaryEncode(to: binaryEncoder)
            let size = encoded.count - RecordHeader.binaryEncodedSize + ((type == GroupRecord.tag) ? 24 : 0)
            try UInt32(size).encode(to: binaryEncoder)
            try encoded.encode(to: binaryEncoder)
        }
        
        return binaryEncoder.data
    }
    
    enum Error: Swift.Error {
        case wrongFileExtension
    }
    
    func loadESPS(_ url: URL) throws -> ESPBundle {
        guard url.pathExtension == "esps" else { throw Error.wrongFileExtension }

        let loaded = try loadRecords(from: url)
        return ESPBundle(records: loaded)
    }

    func loadRecords(from url: URL) throws -> [RecordProtocol] {
        let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

        var loaded: [RecordProtocol] = []
        let decoder = JSONDecoder()
        for url in urls {
            if url.pathExtension == GroupRecord.fileExtension {
                // handle groups
                let headerURL = url.appendingPathComponent("header.json")
                let data = try Data(contentsOf: headerURL)
                let header = try decoder.decode(RecordHeader.self, from: data)
                let contentURL = url.appendingPathComponent("records")
                let children = try loadRecords(from: contentURL)
                let group = GroupRecord(header: header, children: children)
                loaded.append(group)
            } else {
                let data = try Data(contentsOf: url)
                let stub = try decoder.decode(RecordStub.self, from: data)
                let type = configuration.recordClass(for: stub._header.type)
                do {
                    let decoded = try type.fromJSON(data, with: self)
                    loaded.append(decoded)
                } catch {
                    print("Couldn't load record \(type): \(error)")
                }
            }
        }
        
        return loaded
    }

}

struct RecordStub: Codable {
    let _header: RecordHeader
}
