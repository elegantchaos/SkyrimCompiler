// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct DecalData: Codable {
    let minWidth: Float
    let maxWidth: Float
    let minHeight: Float
    let maxHeight: Float
    let depth: Float
    let shininess: Float
    let parallaxScale: Float
    let parallaxPasses: UInt8
    let flags: UInt8
    let unknown1: UInt8
    let unknown2: UInt8
    let rgb: UInt32
}
