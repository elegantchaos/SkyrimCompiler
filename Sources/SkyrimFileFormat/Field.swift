// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

class Field: CustomStringConvertible {
    let type: Tag
    let size: UInt16
    let data: Bytes

    init<S: AsyncIteratorProtocol>(_ iterator: inout AsyncBufferedIterator<S>) async throws where S.Element == UInt8 {
        let tag = try await iterator.next(littleEndian: UInt32.self)
        self.type = Tag(tag)
        self.size = try await iterator.next(littleEndian: UInt16.self)
        self.data = try await iterator.next(bytes: Bytes.self, count: Int(size))
    }

    var description: String {
        return "«field \(type)»"
    }
    
    var children: BytesAsyncSequence {
        return BytesAsyncSequence(bytes: [])
    }
}
