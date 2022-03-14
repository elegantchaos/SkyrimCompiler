// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct AlternateTextureField: BinaryCodable, Equatable {
    let textures: [AlternateTexture]

    init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        let count = try container.decode(UInt32.self)
        textures = try container.decodeArray(of: AlternateTexture.self, count: count)
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(UInt32(textures.count))
        for texture in textures {
            try container.encode(texture)
        }
    }

    struct AlternateTexture: BinaryCodable, Equatable {
        let name: String
        let texture: FormID
        let index: UInt32
        
        init(fromBinary decoder: BinaryDecoder) throws {
            var container = try decoder.unkeyedContainer()
            let size = try container.decode(UInt32.self)
            let bytes = try container.decodeArray(of: UInt8.self, count: size)
            guard let name = String(bytes: bytes, encoding: .ascii) else {
                throw SkyrimFileError.badString
            }
            
            self.name = name
            self.texture = try container.decode(FormID.self)
            self.index = try container.decode(UInt32.self)
        }
        
        func binaryEncode(to encoder: BinaryEncoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(UInt32(name.count))
            try container.encode(name.data(using: encoder.skyrimStringEncoding))
            try container.encode(texture)
            try container.encode(index)
        }
    }
}
