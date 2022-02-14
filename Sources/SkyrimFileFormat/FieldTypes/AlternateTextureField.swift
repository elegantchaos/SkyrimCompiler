// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct AlternateTextureField: Codable {
    let textures: [AlternateTexture]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let count = try container.decode(UInt32.self)
        textures = try container.decodeArray(of: AlternateTexture.self, count: count)
    }
    
    struct AlternateTexture: Codable {
        let name: String
        let texture: FormID
        let index: UInt32
        
        init(from decoder: Decoder) throws {
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
    }
}
