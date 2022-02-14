// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct FormID: Codable {
    let id: UInt32
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        id = try container.decode(UInt32.self)
        name = ""
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
