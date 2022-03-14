// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import BinaryCoding
import Bytes
import Compression
import Logger
import Foundation
import SWCompression

let compressionChannel = Channel("Compression")

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

/// Performs four main operations on ESPs:
///
/// - load: takes an `.esps` bundle and returns an `ESPBundle` instance
/// - save: takes an `ESPBundle` instance and outputs an `.esps` bundle
/// - unpack: takes an `.esp` file and returns an `ESPBundle` instance
/// - pack: takes an `ESPBundle` instance and outputs an `.esp` file
/// 
public class Processor {
    public init(configuration: Configuration = .defaultConfiguration) {
        self.configuration = configuration
        self.jsonEncoder = JSONEncoder()
        self.jsonDecoder = JSONDecoder()

        jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }
    
    let configuration: Configuration
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder
    
    /// Load a bundle of records from an `.esps` directory.
    public func load(url: URL) throws -> ESPBundle {
        let records = try loadRecords(from: url)
        let name = url.deletingPathExtension().lastPathComponent
        return ESPBundle(name: name, records: records)
    }
    
    /// Save a bundle to an `.esps` directory in a given location.
    /// Returns the URL to the saved directory.
    @discardableResult public func save(_ bundle: ESPBundle, to folder: URL) async throws -> URL {
        let url = folder.appendingPathComponent(bundle.name).appendingPathExtension("esps")
        let fm = FileManager.default
        try? fm.removeItem(at: url)
        try? fm.createDirectory(at: url, withIntermediateDirectories: true)
        try await save(records: bundle.records, to: url)
        return url
    }
    
    /// Unpack an `.esp` file
    public func unpack(url: URL) async throws -> ESPBundle {
        let name = url.deletingPathExtension().lastPathComponent
        return try await unpack(name: name, bytes: url.resourceBytes)
    }

    /// Unpack an `.esp` file from a byte stream
    public func unpack<I: AsyncByteSequence>(name: String, bytes: I) async throws -> ESPBundle {
        var unpacked: [RecordProtocol] = []
        for try await record in records(bytes: bytes, processChildren: true) {
            unpacked.append(record)
        }
        
        return ESPBundle(name: name, records: unpacked)
    }

    /// Pack a bundle to an `.esp` file
    public func pack(_ bundle: ESPBundle, to url: URL) throws {
        let data = try pack(bundle)
        try data.write(to: url, options: .atomic)
    }
    
    /// Pack a bundle to Data
    public func pack(_ bundle: ESPBundle) throws -> Data {
        return try pack(records: bundle.records)
    }
    
    /// Pack a single record to Data
    public func pack(_ record: RecordProtocol) throws -> Data {
        let encoder = DataEncoder()
        encoder.userInfo[.configurationUserInfoKey] = configuration
        try record.binaryEncode(to: encoder)
        return encoder.data
    }
}

private extension Processor {
    func recordData<I: AsyncByteSequence>(bytes: I) -> AsyncThrowingIteratorMapSequence<I, RecordData> {
        let records = bytes.iteratorMap { iterator -> RecordData in
            let stream = AsyncDataStream(iterator: iterator)
            let type = try await Tag(stream.read(UInt32.self))
            let size = try await stream.read(UInt32.self)
            let header = try await RecordHeader(type: type, stream)
            let isGroup = type == GroupRecord.tag
            let data: LoadedRecordData
            if !isGroup, header.isCompressed {
                // TODO: defer decompression - move it into RecordData
                let decompressedSize = try await stream.read(UInt32.self)
                let bytes = try await stream.read(count: Int(size - 4))
                compressionChannel.log("Unarchiving data for \(type) (\(decompressedSize) bytes)")
                let decompressed = try ZlibArchive.unarchive(archive: Data(bytes: bytes, count: bytes.count))
                data = LoadedRecordData(data: decompressed.littleEndianBytes)
                if data.data.count != decompressedSize {
                    compressionChannel.log("Size mismatch: only got \(data.data.count) bytes, expected \(decompressedSize).")
                }
            } else {
                let payloadSize = Int(isGroup ? size - 24 : size)
                let bytes = try await stream.read(count: payloadSize)
                data = LoadedRecordData(data: bytes)
            }
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
            if record.header.groupType == .top {
                var children: [RecordProtocol] = []
                if processChildren {
                    do {
                        for try await child in recordData(bytes: record.data.asyncBytes) {
                            children.append(try await self.record(from: child, processChildren: processChildren))
                        }
                    } catch {
                        print("Error decoding children of \(record.header)")
                        print("Managed to decode: \(children.map({ $0.description }).joined(separator: ", "))")
                        print(error)
                    }
                }
                
                return GroupRecord(header: record.header, children: children)
            } else {
                return try RawGroupRecord(header: record.header, data: record.data)
            }
        } else {
            let fields = try await decodedFields(type: record.type, header: record.header, data: record.data)
            let recordClass = configuration.recordClass(for: record.type)
            let decoder = RecordDecoder(header: record.header, fields: fields, data: record.data)
            return try recordClass.init(from: decoder)
        }
    }
    
    func fields<I>(bytes: inout I, types: FieldTypeMap, inRecord recordType: Tag, withHeader recordHeader: RecordHeader) -> AsyncThrowingIteratorMapSequence<I, Field> where I: AsyncSequence, I.Element == Byte {
        let sequence = bytes.iteratorMap { iterator -> Field in
            let header = try await Field.Header(&iterator)
            do {
                let data = try await iterator.next(bytes: Bytes.self, count: Int(header.size))
                return try await self.inflate(header: header, data: data, types: types, inRecord: recordType, withHeader: recordHeader)
            } catch {
                throw error
            }
        }
        
        return sequence
    }
    
    func decodedFields(type: Tag, header: RecordHeader, data: RecordDataProvider) async throws -> DecodedFields {
        let map = try configuration.fields(forRecord: type)
        let fields = DecodedFields(map, for: type, header: header)
        
        var bytes = data.asyncBytes
        
        let fieldStream = self.fields(bytes: &bytes, types: map, inRecord: type, withHeader: header)
        for try await field in fieldStream {
            try fields.add(field)
        }
        fields.moveUnprocesed()
        
        return fields
    }
    
    func inflate(header: Field.Header, data: Bytes, types: FieldTypeMap, inRecord recordType: Tag, withHeader recordHeader: RecordHeader) async throws -> Field {
        if let type = types.fieldType(forTag: header.type) {
            do {
                let decoder = FieldDecoder(header: header, data: data, inRecord: recordType, withHeader: recordHeader)
                let unpacked = try type.init(fromBinary: decoder)
                return Field(header: header, value: unpacked)
            } catch {
                print("Unpack failed. Falling back to basic field.\n\n\(error)")
            }
        }

        return Field(header: header, value: data)
    }

    
    func save(records: [RecordProtocol], to url: URL) async throws {
        var index = 0
        for record in records {
            if let group = record as? GroupRecord {
                try await save(group: group, index: index, asJSONTo: url)
            } else {
                try await save(record: record, index: index, asJSONTo: url)
            }
            index += 1
        }
    }

    
    func save(record: RecordProtocol, index: Int, asJSONTo url: URL) async throws {
        var label = record.name
        if let identified = record as? IdentifiedRecord {
            label = "\(identified.editorID) \(label)"
        }

        let name = String(format: "%04d %@", index, label)
        let recordURL = url.appendingPathComponent(name)

        let encoded = try record.asJSON(with: self)
        try encoded.write(to: recordURL.appendingPathExtension("json"), options: .atomic)
    }
    
    
    func save(group: GroupRecord, index: Int, asJSONTo url: URL) async throws {
        let name = String(format: "%04d %@", index, group.name)
        let groupURL = url.appendingPathComponent(name).appendingPathExtension(GroupRecord.fileExtension)

        try FileManager.default.createDirectory(at: groupURL, withIntermediateDirectories: true)

        let header = group.header
        let headerURL = groupURL.appendingPathComponent(RecordMetadata.fileName)
        let encoded = try jsonEncoder.encode(header)
        try encoded.write(to: headerURL, options: .atomic)

        let childrenURL = groupURL.appendingPathComponent("records")
        try FileManager.default.createDirectory(at: childrenURL, withIntermediateDirectories: true)

        try await save(records: group._children, to: childrenURL)
    }
    
    func pack(records: [RecordProtocol]) throws -> Data {
        let binaryEncoder = DataEncoder()
        binaryEncoder.userInfo[.configurationUserInfoKey] = configuration

        for record in records {
            try record.binaryEncode(to: binaryEncoder)
        }
        
        return binaryEncoder.data
    }
        
    enum Error: Swift.Error {
        case wrongFileExtension
    }
    
    func loadRecords(from url: URL) throws -> [RecordProtocol] {
        let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

        var loaded: [RecordProtocol] = []
        let decoder = JSONDecoder()
        for url in urls {
            if url.pathExtension == GroupRecord.fileExtension {
                // handle groups
                let headerURL = url.appendingPathComponent(RecordMetadata.fileName)
                let data = try Data(contentsOf: headerURL)
                let header = try decoder.decode(RecordHeader.self, from: data)
                let contentURL = url.appendingPathComponent("records")
                let children = try loadRecords(from: contentURL)
                let group = GroupRecord(header: header, children: children)
                loaded.append(group)
            } else {
                let data = try Data(contentsOf: url)
                let stub = try decoder.decode(RecordStub.self, from: data)
                let type = configuration.recordClass(for: stub._meta.type)
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
    let _meta: RecordHeader
}
