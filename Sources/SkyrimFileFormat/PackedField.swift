// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct PackedField: Codable {
    let type: String
    let data: String
    
    init(_ field: Field) {
        self.type = field.header.type.description
        self.data = field.data.map({ String(format: "%02X", $0)}).joined(separator: "")
    }
}
