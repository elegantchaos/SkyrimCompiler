// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct LVLIRecord: IdentifiedRecord {
    static var tag = Tag("LVLI")

    let _header: RecordHeader
    let _fields: UnpackedFields?

    let editorID: String
    let bounds: OBNDField
    let noSpawnChance: Int8
    let flags: Int8
    let noSpawnGlobal: FormID?
    let count: Int8?
    let items: [LevelledItem]
    
    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.bounds, \.bounds, "OBND"),
        (.noSpawnChance, \.noSpawnChance, "LVLD"),
        (.flags, \.flags, "LVLF"),
        (.noSpawnGlobal, \.noSpawnGlobal, "LVLG"),
        (.count, \.count, "LLCT"),
        (.items, \.items, "LVLO"),
    ])
    
    struct LevelledItem: Codable {
        let level: UInt32
        let item: FormID
        let amount: UInt32
    }
}
