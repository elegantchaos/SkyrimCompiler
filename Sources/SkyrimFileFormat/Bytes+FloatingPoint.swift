// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

// NB: We could throw an error if passed an unsupported float size, but these feel
//     like primitive operations which should not require a try/catch block, so
//     I've chosen to use fatalError instead.

extension BinaryFloatingPoint {
    init(littleEndianBytes bytes: ArraySlice<Byte>) throws {
        switch MemoryLayout<Self>.size {
            case 1: self = unsafeBitCast(try UInt8(littleEndianBytes: bytes), to: Self.self)
            case 2: self = unsafeBitCast(try UInt16(littleEndianBytes: bytes), to: Self.self)
            case 4: self = unsafeBitCast(try UInt32(littleEndianBytes: bytes), to: Self.self)
            case 8: self = unsafeBitCast(try UInt64(littleEndianBytes: bytes), to: Self.self)
            default: fatalError("Unsupported float type \(Self.self)")
        }
    }

    var littleEndianBytes: Bytes {
        switch MemoryLayout<Self>.size {
            case 1: return unsafeBitCast(self, to: UInt8.self).littleEndianBytes
            case 2: return unsafeBitCast(self, to: UInt16.self).littleEndianBytes
            case 4: return unsafeBitCast(self, to: UInt32.self).littleEndianBytes
            case 8: return unsafeBitCast(self, to: UInt64.self).littleEndianBytes
            default: fatalError("Unsupported float type \(Self.self)")
        }
    }
}
