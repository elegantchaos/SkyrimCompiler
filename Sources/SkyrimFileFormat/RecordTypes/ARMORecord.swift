// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Bytes
import Foundation


struct ARMORecord: Codable, IdentifiedRecord {
    static var tag = Tag("ARMO")
    
    let _header: RecordHeader
    let _fields: UnpackedFields?

    let editorID: String
    let bounds: OBNDField
    let fullName: String?
    let enchantment: FormID?
    let enchantmentAmount: UInt16?
    let maleArmour: String
    let maleModelData: MODTField?
    let maleTextures: AlternateTextureField?
    let maleInventoryImage: String?
    let maleMessageImage: String?
    let femaleArmour: String?
    let femaleModelData: MODTField?
    let femaleTextures: AlternateTextureField?
    let femaleInventoryImage: String?
    let femaleMessageImage: String?
    let bodyTemplate: BOD2Field
    let pickupSound: FormID
    let dropSound: FormID
    let equipSlot: FormID?
    let bashImpactDataSet: FormID?
    let bashMaterial: FormID?
    let race: FormID
    let keywordCount: UInt32
    let keywords: SingleFieldArray<FormID>
    let desc: String
    let armature: [FormID]
    let data: DATAField
    let armourRating: UInt32
    let template: FormID?

    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.bounds, \.bounds, "OBND"),
        (.fullName, \.fullName, "FULL"),
        (.enchantment, \.enchantment, "EITM"),
        (.enchantmentAmount, \.enchantmentAmount, "EAMT"),
        (.maleArmour, \.maleArmour, "MOD2"),
        (.maleModelData, \.maleModelData, "MO2T"),
        (.maleTextures, \.maleTextures, "MO2S"),
        (.maleInventoryImage, \.maleInventoryImage, "ICON"),
        (.maleMessageImage, \.maleMessageImage, "MICO"),
        (.femaleArmour, \.femaleArmour, "MOD4"),
        (.femaleModelData, \.femaleModelData, "MO4T"),
        (.femaleTextures, \.femaleTextures, "MO4S"),
        (.femaleInventoryImage, \.femaleInventoryImage, "ICO2"),
        (.femaleMessageImage, \.femaleMessageImage, "MIC2"),
        (.bodyTemplate, \.bodyTemplate, "BOD2"),
        (.pickupSound, \.pickupSound, "YNAM"),
        (.dropSound, \.dropSound, "ZNAM"),
        (.equipSlot, \.equipSlot, "ETYP"),
        (.bashImpactDataSet, \.bashImpactDataSet, "BIDS"),
        (.bashMaterial, \.bashMaterial, "BAMT"),
        (.race, \.race, "RNAM"),
        (.keywordCount, \.keywordCount, "KSIZ"),
        (.keywords, \.keywords, "KWDA"),
        (.desc, \.desc, "DESC"),
        (.armature, \.armature, "MODL"),
        (.data, \.data, "DATA"),
        (.armourRating, \.armourRating, "DNAM"),
        (.template, \.template, "TNAM"),
    ])
    
    struct DATAField: BinaryCodable {
        let base: UInt32
        let weight: Float
    }
}


extension ARMORecord: CustomStringConvertible {
    var description: String {
        return "«armour \(fullName ?? editorID)»"
    }
}
