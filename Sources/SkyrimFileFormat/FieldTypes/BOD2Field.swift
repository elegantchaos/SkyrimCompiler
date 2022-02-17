// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct BOD2Field: BinaryCodable {
    let partFlags: PartNodeFlags
    let armorType: ArmorType

    enum ArmorType: String, DecodableFromIntOrString {
        case light
        case heavy
        case clothing
    }
}

