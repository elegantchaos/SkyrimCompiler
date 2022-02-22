// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import ElegantStrings
import Foundation

struct FormID: BinaryCodable {
    let id: UInt32
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(UInt32.self) {
            id = int
        } else {
            let string = try container.decode(String.self)
            guard let value = string.hexValue else {
                // TODO: in theory we could use a non-hex value as a lookup in an index of forms, instead of just failing
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected hex string")
                
            }
            id = UInt32(value)
        }

        name = "" // TODO: in theory we could look up the name/editorID from an index and fill it in here
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let extra = name.isEmpty ? "" : " \(name)"
        try container.encode(String(format: "0x%08X%@", id, extra))
    }

    enum CodingKeys: CodingKey {
        case id
        case name
    }
}
