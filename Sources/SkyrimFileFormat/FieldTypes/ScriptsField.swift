// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding

struct ScriptsField: BinaryCodable {
    let version: Int16
    let objFormat: Int16
    let scriptCount: UInt16

    struct Script: Codable {
        let name: String
        let status: UInt8
        let propertyCount: UInt16
        let properties: [Property]
    }

    struct Property: Codable {
        let name: String
        let type: UInt8
        let status: UInt8
        
    }

}

