// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

protocol ByteIterator: AsyncIteratorProtocol where Element == Byte {
}

class Record: CustomStringConvertible {
    
    required init(header: RecordHeader, data: Bytes, processor: ProcessorProtocol) async throws {
        self.header = header
        self.data = data
    }
    
    let header: RecordHeader
    let data: Bytes

    var description: String {
        return "«\(header.type) \(String(format: "0x%08X", header.id))»"
    }
    
    var childData: BytesAsyncSequence {
        return BytesAsyncSequence(bytes: [])
    }

    var name: String {
        header.type.description
    }
    
    func pack(to url: URL, processor: Processor) async throws {
        let map = try processor.configuration.fields(forRecord: header.type.description)
        let fp = FieldProcessor(map)
        try await fp.process(data: data, processor: processor)

        let packed: RecordProperties.Type = processor.configuration.records[header.type] ?? PackedRecord.self
        let encoded = try packed.pack(header: header, fields: fp, with: processor)
        try encoded.write(to: url.appendingPathExtension("json"), options: .atomic)
    }
}


extension Tag {
    static let group: Tag = "GRUP"
}

struct RecordHeader: Codable {
    let type: Tag
    let size: UInt32
    let flags: UInt32
    let id: UInt32
    let timestamp: UInt16
    let versionInfo: UInt16
    let version: UInt16
    let unused: UInt16
    
    init<S: AsyncIteratorProtocol>(_ iterator: inout AsyncBufferedIterator<S>) async throws where S.Element == UInt8 {
        let tag = try await iterator.next(littleEndian: UInt32.self)
        self.type = Tag(tag)
        self.size = try await iterator.next(littleEndian: UInt32.self)
        self.flags = try await iterator.next(littleEndian: UInt32.self)
        self.id = try await iterator.next(littleEndian: UInt32.self)
        self.timestamp = try await iterator.next(littleEndian: UInt16.self)
        self.versionInfo = try await iterator.next(littleEndian: UInt16.self)
        self.version = try await iterator.next(littleEndian: UInt16.self)
        self.unused = try await iterator.next(littleEndian: UInt16.self)
    }
    
    var isGroup: Bool {
        return type == .group
    }
    
    func payload<S>(_ iterator: inout AsyncBufferedIterator<S>) async throws -> Bytes  where S.Element == UInt8 {
        let size = Int(isGroup ? self.size - 24 : self.size)
        return try await iterator.next(bytes: Bytes.self, count: size)
    }
}

