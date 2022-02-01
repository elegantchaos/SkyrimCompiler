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
    
    func children() -> BytesSequence {
        return BytesSequence(bytes: [])
    }
}

struct BytesSequence: AsyncSequence {
    let bytes: [UInt8]
    
    func makeAsyncIterator() -> BytesAsyncIterator {
        BytesAsyncIterator(bytes: bytes)
    }
    
    typealias AsyncIterator = BytesAsyncIterator
    typealias Element = UInt8
}
struct BytesAsyncIterator: AsyncIteratorProtocol {
    let bytes: [UInt8]
    var index = 0
    mutating func next() async throws -> UInt8? {
        guard index < bytes.count else { return nil }
        let value = bytes[index]
        index += 1
        return value
    }
    
    typealias Element = UInt8
    
    
}
extension Record {
    
    struct Header {
        let type: String
        let size: UInt32
        let flags: UInt32
        let id: UInt32
        let timestamp: UInt16
        let versionInfo: UInt16
        let version: UInt16
        let unused: UInt16
        
        init<S: AsyncIteratorProtocol>(_ iterator: inout AsyncBufferedIterator<S>) async throws where S.Element == UInt8 {
            let bytes = try await iterator.next(bytes: [UInt8].self, count: 4)
            guard let type = String(bytes: bytes, encoding: .ascii) else { throw SkyrimFileError.badTag}
            self.type = type
            
            self.size = try await iterator.next(littleEndian: UInt32.self)
            self.flags = try await iterator.next(littleEndian: UInt32.self)
            self.id = try await iterator.next(littleEndian: UInt32.self)
            self.timestamp = try await iterator.next(littleEndian: UInt16.self)
            self.versionInfo = try await iterator.next(littleEndian: UInt16.self)
            self.version = try await iterator.next(littleEndian: UInt16.self)
            self.unused = try await iterator.next(littleEndian: UInt16.self)
        }
    }

}
