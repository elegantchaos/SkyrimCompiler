// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Foundation

class Record: CustomStringConvertible {
    internal init(header: Header) {
        self.header = header
    }
    
    let header: Header

    var description: String {
        return "«record \(header.type)»"
    }
    
    var children: BytesAsyncSequence {
        return BytesAsyncSequence(bytes: [])
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
