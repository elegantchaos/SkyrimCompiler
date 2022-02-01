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
    required init<S>(header: Header, iterator: inout AsyncBufferedIterator<S>, configuration: Configuration) async throws where S.Element == Byte {
        self.header = header

        // TODO: alternate mechanism allowing deferral of data read?
        
        let size = Int(header.isGroup ? header.size - 24 : header.size)
        self.data = try await iterator.next(bytes: Bytes.self, count: size)
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
}


extension Tag: CustomStringConvertible {
    var description: String {
        if let string = String(bytes: tag.littleEndianBytes, encoding: .ascii) {
            return string
        }
        
        return "\(tag)"
    }
}

extension Record {
    
    struct Header {
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
//            guard let type = RecordType(tag) else { throw SkyrimFileError.badTag }
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
    }

}
