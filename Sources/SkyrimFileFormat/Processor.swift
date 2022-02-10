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

protocol RecordSequence: AsyncSequence where Element == Record {
}

extension AsyncThrowingIteratorMapSequence: RecordSequence where Element == Record {
}

class Processor {
    internal init(configuration: Configuration) {
        self.configuration = configuration
        self.encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
    }
    
    let configuration: Configuration
    let encoder: JSONEncoder
    
    
    
    func records<I: AsyncByteSequence>(bytes: I) -> AsyncThrowingIteratorMapSequence<I, Record> {
        let records = bytes.iteratorMap { iterator -> Record in
            let stream = AsyncDataStream(iterator: iterator)
            let type = try await Tag(stream.read(UInt32.self))
            let size = try await stream.read(UInt32.self)
            let header = try await RecordHeader(type: type, stream)
            let payloadSize = Int(type == GroupRecord.tag ? size - 24 : size)
            let data = try await stream.read(count: payloadSize)
            iterator = stream.iterator

            return try await Record(type: type, header: header, data: data)
        }

        return records
    }

    func realisedRecords<I: AsyncByteSequence>(bytes: I, processChildren: Bool) -> RealisedRecordSequence<I> {
        let records = RealisedRecordSequence(data: bytes, processor: self, processChildren: processChildren)
        return records
    }

    
    func fields<I>(bytes: inout I, types: FieldTypeMap) -> AsyncThrowingIteratorMapSequence<I, Field> where I: AsyncSequence, I.Element == Byte {
        let sequence = bytes.iteratorMap { iterator -> Field in
            let header = try await Field.Header(&iterator)
            let data = try await iterator.next(bytes: Bytes.self, count: Int(header.size))
            return try await self.inflate(header: header, data: data, types: types)
        }
        
        return sequence
    }
    
    func decodedFields(type: Tag, data: Bytes) async throws -> DecodedFields {
        let map = try configuration.fields(forRecord: type)
        let fp = DecodedFields(map)
        
        var bytes = BytesAsyncSequence(bytes: data)
        
        let fields = fields(bytes: &bytes, types: map)
        for try await field in fields {
            try fp.add(field)
        }

        return fp
    }
    
    func inflate(header: Field.Header, data: Bytes, types: FieldTypeMap) async throws -> Field {
        do {
            if let type = types.fieldType(forTag: header.type) {
                let decoder = FieldDecoder(header: header, data: data)
                let unpacked = try type.init(from: decoder)
                return Field(header: header, value: unpacked)
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic field.\n\n\(error)")
        }
        
        return Field(header: header, value: data)
    }

    
    func pack<I: AsyncByteSequence>(bytes: I, to url: URL) async throws {
        let records = records(bytes: bytes)
        var index = 0
        for try await record in records {
            do {
                let name = String(format: "%04d %@", index, record.name)
                print("exporting \(name)")
                let recordURL = url.appendingPathComponent(name)
                if record.isGroup {
                    try await export(group: record, asJSONTo: recordURL)
                } else {
                    try await export(record: record, asJSONTo: recordURL)
                }
            } catch {
                print(error)
            }
            index += 1
        }
    }

    
    func export(record: Record, asJSONTo url: URL) async throws {
        let header = record.header
        let fields = try await decodedFields(type: record.type, data: record.data)
        let recordClass = configuration.records[record.type] ?? RawRecord.self
        
        let decoder = RecordDecoder(header: header, fields: fields)
        let record = try recordClass.init(from: decoder)
        let encoded = try record.asJSON(with: self)
        try encoded.write(to: url.appendingPathExtension("json"), options: .atomic)
    }
    
    
    func export(group: Record, asJSONTo url: URL) async throws {
        let groupURL = url.appendingPathExtension("epsg")
        try FileManager.default.createDirectory(at: groupURL, withIntermediateDirectories: true)
        
        let header = group.header
        let headerURL = groupURL.appendingPathComponent("header.json")
        let encoded = try encoder.encode(header)
        try encoded.write(to: headerURL, options: .atomic)

        let childrenURL = groupURL.appendingPathComponent("records")
        try FileManager.default.createDirectory(at: childrenURL, withIntermediateDirectories: true)

        try await pack(bytes: group.data.asyncBytes, to: childrenURL)
    }
}

