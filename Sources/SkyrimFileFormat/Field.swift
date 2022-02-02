// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

class Field: CustomStringConvertible {
    class var tag: Tag { "????" }
    
    let header: Header
    let data: Bytes

    required init<S: AsyncIteratorProtocol>(header: Header, iterator: inout AsyncBufferedIterator<S>, configuration: Configuration) async throws where S.Element == UInt8 {
        self.header = header
        self.data = try await iterator.next(bytes: Bytes.self, count: Int(header.size))
    }

    init(header: Header) {
        self.header = header
        self.data = []
    }
    
    var description: String {
        return "«field \(header.type)»"
    }
}

extension Field {
    struct Header {
        let type: Tag
        let size: UInt16

        init<S: AsyncIteratorProtocol>(_ iterator: inout AsyncBufferedIterator<S>) async throws where S.Element == UInt8 {
            let tag = try await iterator.next(littleEndian: UInt32.self)
            self.type = Tag(tag)
            self.size = try await iterator.next(littleEndian: UInt16.self)
        }
    }
}
