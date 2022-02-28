// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct ARMARecord: IdentifiedRecord {
    static var tag = Tag("ARMA")
    
    let _header: RecordHeader
    let _fields: UnpackedFields?
    
    let editorID: String
    let bodyTemplate: BOD2Field
    let primaryRace: FormID
    let unknown: DNAMField
    let model2: String
    let model2Textures: MODTField?
    let model2AlternateTextures: [AlternateTextureField]
    let model3: String?
    let model3Textures: MODTField?
    let model3AlternateTextures: [AlternateTextureField]
    let model4: String?
    let model4Textures: MODTField?
    let model4AlternateTextures: [AlternateTextureField]
    let model5: String?
    let model5Textures: MODTField?
    let model5AlternateTextures: [AlternateTextureField]
    let baseMaleTexture: FormID?
    let baseFemaleTexture: FormID?
    let baseMaleFirstPersonTexture: FormID?
    let baseFemaleFirstPersonTexture: FormID?
    let races: [FormID]
    let footstepSound: FormID?
    let artObject: FormID?

    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.bodyTemplate, \.bodyTemplate, "BOD2"),
        (.primaryRace, \.primaryRace, "RNAM"),
        (.unknown, \.unknown, "DNAM"),
        (.model2, \.model2, "MOD2"),
        (.model2Textures, \.model2Textures, "MO2T"),
        (.model2AlternateTextures, \.model2AlternateTextures, "MO2S"),
        (.model3, \.model3, "MOD3"),
        (.model3Textures, \.model3Textures, "MO3T"),
        (.model3AlternateTextures, \.model3AlternateTextures, "MO3S"),
        (.model4, \.model4, "MOD4"),
        (.model4Textures, \.model4Textures, "MO4T"),
        (.model4AlternateTextures, \.model4AlternateTextures, "MO4S"),
        (.model5, \.model5, "MOD5"),
        (.model5Textures, \.model5Textures, "MO5T"),
        (.model5AlternateTextures, \.model5AlternateTextures, "MO5S"),
        (.baseMaleTexture, \.baseMaleTexture, "NAM0"),
        (.baseFemaleTexture, \.baseFemaleTexture, "NAM1"),
        (.baseMaleFirstPersonTexture, \.baseMaleFirstPersonTexture, "NAM2"),
        (.baseFemaleFirstPersonTexture, \.baseFemaleFirstPersonTexture, "NAM3"),
        (.races, \.races, "MODL"),
        (.footstepSound, \.footstepSound, "SNDD"),
        (.artObject, \.artObject, "ONAM")
    ])
    
    struct DNAMField: BinaryCodable {
        let malePriority: UInt8
        let femalePriority: UInt8
        let unknown: UInt32
        let detectionSound: UInt8
        let unknown2: UInt8
        let weaponAdjust: Float32
    }
}
