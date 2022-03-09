// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct LVLIRecord: IdentifiedRecord {
    static var tag = Tag("LVLI")

    let _meta: RecordMetadata

    let editorID: String
    let bounds: OBNDField
    let noSpawnChance: Int8
    let flags: LevelledListFlags
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
    
    struct LevelledItem: BinaryCodable {
        let level: UInt32
        let item: FormID
        let amount: UInt32
    }

    public struct LevelledListFlags: BinaryCodable, OptionSetFromEnum {
        public enum Options: String, EnumForOptionSet {
            case allLevels
            case eachTime
            case useAll
            case specialLoot
        }
        
        public let rawValue: UInt8
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
    }
}

