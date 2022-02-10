// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

typealias FormID = UInt32
//struct FormID: Codable {
//    let id: UInt32
//}

struct ARMORecord: Codable, RecordProtocol {
    static var tag = Tag("ARMO")
    
    let header: RecordHeader
    let editorID: String
    let bounds: OBNDField
    let fullName: String?
    let maleArmour: String
    let maleInventoryImage: String?
    let maleMessageImage: String?
    let femaleArmour: String?
    let femaleInventoryImage: String?
    let femaleMessageImage: String?
    let pickupSound: FormID
    let dropSound: FormID
    let keywordCount: UInt32
    let keywords: SingleFieldArray<FormID>
    let fields: [UnpackedField]?

    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.bounds, \.bounds, "OBND"),
        (.fullName, \.fullName, "FULL"),
        (.maleArmour, \.maleArmour, "MOD2"),
        (.maleInventoryImage, \.maleInventoryImage, "ICON"),
        (.maleMessageImage, \.maleMessageImage, "MICO"),
        (.femaleArmour, \.femaleArmour, "MOD4"),
        (.femaleInventoryImage, \.femaleInventoryImage, "ICO2"),
        (.femaleMessageImage, \.femaleMessageImage, "MIC2"),
        (.pickupSound, \.pickupSound, "YNAM"),
        (.dropSound, \.dropSound, "ZNAM"),
        (.keywordCount, \.keywordCount, "KSIZ"),
        (.keywords, \.keywords, "KWDA")
        ]
    )
    
    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }
}


extension ARMORecord: CustomStringConvertible {
    var description: String {
        return "«armour \(fullName ?? editorID)»"
    }
}
