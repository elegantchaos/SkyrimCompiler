// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct TES4Header: Codable {
    let version: Float32
    let number: UInt32
    let nextID: UInt32
}

extension TES4Header: MapDecodable {
    init() {
        version = 0
        number = 0
        nextID = 0
    }
}
