// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct UnpackedField: Codable {
    let type: String
    let data: String
    
    init(_ field: Field) {
        self.type = field.header.type.description
        let data = field.value as? Bytes ?? []
        self.data = data.map({ String(format: "%02X", $0)}).joined(separator: "")
    }
}
