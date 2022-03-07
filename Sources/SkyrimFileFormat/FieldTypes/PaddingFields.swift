// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct Padding3: BinaryCodable {
    init() {
    }
    
    init(from decoder: Decoder) throws {
    }
    
    func encode(to encoder: Encoder) throws {
    }
    
    init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(UInt8.self)
        let _ = try container.decode(UInt8.self)
        let _ = try container.decode(UInt8.self)
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = try encoder.unkeyedContainer()
        try container.encode(UInt8(0))
        try container.encode(UInt8(0))
        try container.encode(UInt8(0))
    }
}

