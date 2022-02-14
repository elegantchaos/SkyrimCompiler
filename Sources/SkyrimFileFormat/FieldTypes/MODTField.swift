// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct MODTField: Codable {
    let count: UInt32
    let count2: UInt32
    let count3: UInt32
    let data3: [UInt32]
    let data2: [Data2]
    let data: [UInt32]
    
    init(from decoder: Decoder) throws {
        
        if let fieldDecoder = decoder as? FieldDecoder {
            assert(fieldDecoder.recordHeader.version == 44) // TODO handle older format?
            var container = try decoder.unkeyedContainer()
            count = try container.decode(UInt32.self)
            count2 = (count >= 1) ? try container.decode(UInt32.self) : 0
            count3 = (count >= 2) ? try container.decode(UInt32.self) : 0
            data3 = (count >= 3) ? try container.decodeArray(of: UInt32.self, count: Int(count - 2)) : []
            data2 = try container.decodeArray(of: Data2.self, count: Int(count2))
            data = try container.decodeArray(of: UInt32.self, count: Int(count3))
        } else {
            let container = try decoder.container(keyedBy: Self.CodingKeys)
            count = try container.decode(UInt32.self, forKey: Self.CodingKeys.count)
            count2 = try container.decode(UInt32.self, forKey: Self.CodingKeys.count2)
            count3 = try container.decode(UInt32.self, forKey: Self.CodingKeys.count3)
            data = try container.decode([UInt32].self, forKey: Self.CodingKeys.data)
            data2 = try container.decode([Data2].self, forKey: Self.CodingKeys.data2)
            data3 = try container.decode([UInt32].self, forKey: Self.CodingKeys.data3)

        }
    }
}

struct Data2: Codable {
    let unknown: UInt32
    let textureType: Tag
    let unknown2: UInt32
}
