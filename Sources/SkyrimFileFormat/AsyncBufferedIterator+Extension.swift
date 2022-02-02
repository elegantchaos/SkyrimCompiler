// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

extension AsyncBufferedIterator where Element == Byte {
    @inlinable
    public mutating func next<T: BinaryFloatingPoint>(littleEndian type: T.Type) async throws -> T {
        let bytes = try await next(bytes: Bytes.self, count: MemoryLayout<T>.size)
        switch MemoryLayout<T>.size {
            case 1: return unsafeBitCast(try UInt8(littleEndianBytes: bytes), to: T.self)
            case 2: return unsafeBitCast(try UInt16(littleEndianBytes: bytes), to: T.self)
            case 4: return unsafeBitCast(try UInt32(littleEndianBytes: bytes), to: T.self)
            case 8: return unsafeBitCast(try UInt64(littleEndianBytes: bytes), to: T.self)
            default: fatalError("unhandled size")
        }
    }
}
