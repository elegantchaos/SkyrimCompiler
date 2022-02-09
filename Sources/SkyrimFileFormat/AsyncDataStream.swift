// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

class AsyncDataStream<I: AsyncIteratorProtocol> where I.Element == Byte {
    internal init(iterator: AsyncBufferedIterator<I>) {
        self.iterator = iterator
    }
    
    var iterator: AsyncBufferedIterator<I>
}

extension AsyncDataStream: DataStream {
    func read<T>(_ type: T.Type) async throws -> T where T : FixedWidthInteger {
        try await iterator.next(littleEndian: T.self)
    }

    func read(count: Int) async throws -> Bytes {
        return try await iterator.next(bytes: Bytes.self, count: count)
    }

}
