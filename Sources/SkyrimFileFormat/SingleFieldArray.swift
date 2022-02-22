// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

protocol SingleFieldArrayProtocol: BinaryCodable {
}

struct SingleFieldArray<Value>: SingleFieldArrayProtocol where Value: BinaryCodable {
    let value: [Value]
    
    init(from decoder: Decoder) throws {
        if var container = try? decoder.unkeyedContainer() {
            var result: [Value] = []
            while let item = try? container.decode(Value.self) {
                result.append(item)
            }
            value = result
        } else {
            let container = try decoder.singleValueContainer()
            value = try container.decode([Value].self)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
