// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

struct Field: CustomStringConvertible {
    let header: Header
    let value: Any

    var description: String {
        return "«\(header.type) field»"
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
