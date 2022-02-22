// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct MODTField: Codable {
    let data: [UInt32]
    let data2: [Data2]?
    let data3: [UInt32]?
}

extension MODTField: BinaryCodable {
    init(fromBinary decoder: BinaryDecoder) throws {
        let fieldDecoder = decoder as? FieldDecoder
        assert(fieldDecoder?.version == 44) // TODO handle older format?
        var container = try decoder.unkeyedContainer()
        let count3 = try container.decode(UInt32.self)
        let count2 = (count3 >= 1) ? try container.decode(UInt32.self) : 0
        let count1 = (count3 >= 2) ? try container.decode(UInt32.self) : 0
        let data3 = (count3 >= 3) ? try container.decodeArray(of: UInt32.self, count: Int(count3 - 2)) : []
        let data2 = try container.decodeArray(of: Data2.self, count: Int(count2))
        let data = try container.decodeArray(of: UInt32.self, count: Int(count1))
        
        self.data = data
        self.data2 = data2.count > 0 ? data2 : nil
        self.data3 = data3.count > 0 ? data3 : nil
//        } else {
//            let container = try decoder.container(keyedBy: Self.CodingKeys)
//            data = try container.decode([UInt32].self, forKey: Self.CodingKeys.data)
//            data2 = try container.decode([Data2].self, forKey: Self.CodingKeys.data2)
//            data3 = try container.decode([UInt32].self, forKey: Self.CodingKeys.data3)
//
//        }
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        let count3 = UInt32(data3?.count ?? 0)
        let count2 = UInt32(data2?.count ?? 0)
        let count1 = data.count
        
        var count = count3
        if count2 > 0 {
            count += 1
        }
        if count1 > 0 {
            count += 1
        }
        
        var container = encoder.unkeyedContainer()
        try container.encode(count)
        if count2 > 0 {
            try container.encode(count2)
        }
        if count1 > 0 {
            try container.encode(count1)
        }
        if let items = data3 {
            for value in items {
                try container.encode(value)
            }
        }
        if let items = data2 {
            for item in items {
                try container.encode(item)
            }
        }
        
        for value in data {
            try container.encode(value)
        }
    }
}

struct Data2: BinaryCodable {
    let unknown: UInt32
    let textureType: Tag
    let unknown2: UInt32
}
