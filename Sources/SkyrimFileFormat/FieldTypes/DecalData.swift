// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct DecalData: BinaryCodable {
    let minWidth: Float32
    let maxWidth: Float32
    let minHeight: Float32
    let maxHeight: Float32
    let depth: Float32
    let shininess: Float32
    let parallaxScale: Float32
    let parallaxPasses: UInt8
    let flags: UInt8
    let unknown1: UInt8
    let unknown2: UInt8
    let rgb: RGBColor
}

extension DecalData: Equatable { }
