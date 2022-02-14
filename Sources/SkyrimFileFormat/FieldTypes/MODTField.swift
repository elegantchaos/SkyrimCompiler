// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct MODTField: Codable {
    let data: [UInt32]
    let data2: [Data2]?
    let data3: [UInt32]?

    init(from decoder: Decoder) throws {
        
        if let fieldDecoder = decoder as? FieldDecoder {
            assert(fieldDecoder.recordHeader.version == 44) // TODO handle older format?
            var container = try decoder.unkeyedContainer()
            let count = try container.decode(UInt32.self)
            let count2 = (count >= 1) ? try container.decode(UInt32.self) : 0
            let count3 = (count >= 2) ? try container.decode(UInt32.self) : 0
            let data3 = (count >= 3) ? try container.decodeArray(of: UInt32.self, count: Int(count - 2)) : []
            let data2 = try container.decodeArray(of: Data2.self, count: Int(count2))
            let data = try container.decodeArray(of: UInt32.self, count: Int(count3))
            
            self.data = data
            self.data2 = data2.count > 0 ? data2 : nil
            self.data3 = data3.count > 0 ? data3 : nil
        } else {
            let container = try decoder.container(keyedBy: Self.CodingKeys)
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
