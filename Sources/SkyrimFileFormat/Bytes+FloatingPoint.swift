// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

enum BinaryFloatingPointError: Error {
    case unsupportedFloatSize
}

extension BinaryFloatingPoint {
    
    init(littleEndianBytes bytes: Bytes) throws {
        switch MemoryLayout<Self>.size {
            case 1: self = unsafeBitCast(try UInt8(littleEndianBytes: bytes), to: Self.self)
            case 2: self = unsafeBitCast(try UInt16(littleEndianBytes: bytes), to: Self.self)
            case 4: self = unsafeBitCast(try UInt32(littleEndianBytes: bytes), to: Self.self)
            case 8: self = unsafeBitCast(try UInt64(littleEndianBytes: bytes), to: Self.self)
            default: throw BinaryFloatingPointError.unsupportedFloatSize
        }
    }

    var littleEndianBytes: Bytes {
        get throws {
            switch MemoryLayout<Self>.size {
                case 1: return unsafeBitCast(self, to: UInt8.self).littleEndianBytes
                case 2: return unsafeBitCast(self, to: UInt16.self).littleEndianBytes
                case 4: return unsafeBitCast(self, to: UInt32.self).littleEndianBytes
                case 8: return unsafeBitCast(self, to: UInt64.self).littleEndianBytes
                default: throw BinaryFloatingPointError.unsupportedFloatSize
            }
        }
    }
}
