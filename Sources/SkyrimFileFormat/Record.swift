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
    class var tag: Tag { "????" }
    
    required init(header: Header, data: Bytes, processor: ProcessorProtocol) async throws {
        self.header = header
        self.data = data
    }
    
    let header: Header
    let data: Bytes

    var description: String {
        return "«\(header.type) \(String(format: "0x%08X", header.id))»"
    }
    
    var childData: BytesAsyncSequence {
        return BytesAsyncSequence(bytes: [])
    }

    var fieldData: BytesAsyncSequence {
        return BytesAsyncSequence(bytes: data)
    }

    var name: String {
        header.type.description
    }
    
    func pack(to url: URL, processor: Processor) async throws {
        let fp = FieldProcessor(FieldsMap())
        try await fp.process(data: data, processor: processor)
        let record = PackedRecord(header, fields: fp.unprocessed)
        let encoded = try processor.encoder.encode(record)
        if !record.containsRawFields {
            try encoded.write(to: url.appendingPathExtension("json"), options: .atomic)
        } else {
            let rawURL = url.appendingPathExtension("epsr")
            try FileManager.default.createDirectory(at: rawURL, withIntermediateDirectories: true)
            try encoded.write(to: rawURL.appendingPathComponent("header.json"), options: .atomic)
            if data.count > 0 {
                let raw = Data(bytes: data, count: data.count)
                try raw.write(to: rawURL.appendingPathComponent("data.bin"), options: .atomic)
            }
        }

    }
}


extension Record {
    
    struct Header: Codable {
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
            return type == Group.tag
        }
        
        func payload<S>(_ iterator: inout AsyncBufferedIterator<S>) async throws -> Bytes  where S.Element == UInt8 {
            let size = Int(isGroup ? self.size - 24 : self.size)
            return try await iterator.next(bytes: Bytes.self, count: size)
        }
    }

}

