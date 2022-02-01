// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation


protocol AsyncByteIterator: AsyncIteratorProtocol where Element == Byte {
}

protocol ByteSequence: AsyncSequence where Element == Byte {
}

extension URL.AsyncBytes: ByteSequence {
}

struct BytesAsyncSequence: AsyncSequence {
    let bytes: [UInt8]
    
    func makeAsyncIterator() -> BytesAsyncIterator {
        BytesAsyncIterator(bytes: bytes)
    }
    
    typealias AsyncIterator = BytesAsyncIterator
    typealias Element = UInt8
}

extension BytesAsyncSequence: ByteSequence {
    
}

struct BytesAsyncIterator: AsyncIteratorProtocol {
    let bytes: Bytes
    var index = 0
    mutating func next() async throws -> UInt8? {
        guard index < bytes.count else { return nil }
        let value = bytes[index]
        index += 1
        return value
    }
    
    typealias Element = UInt8
}

extension Bytes {
    var asyncBytes: BytesAsyncSequence {
        BytesAsyncSequence(bytes: self)
    }
}

