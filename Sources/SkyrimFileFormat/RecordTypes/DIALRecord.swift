// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct DIALRecord: IdentifiedRecord {
    static var tag = Tag("DIAL")

    let _meta: RecordMetadata

    let editorID: String?
    let playerDialogue: UInt32
    let priority: Float32
    let owningBranch: FormID?
    let owningQuest: FormID
    let data: DATAField?
    let subtype: UInt32
    let infoCount: UInt32
    
    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.playerDialogue, \.playerDialogue, "FULL"),
        (.priority, \.priority, "PNAM"),
        (.owningBranch, \.owningBranch, "BNAM"),
        (.owningQuest, \.owningQuest, "QNAM"),
        (.playerDialogue, \.playerDialogue, "DATA"),
        (.subtype, \.subtype, "SNAM"),
        (.infoCount, \.infoCount, "TIFC"),

    ])
    
    struct DATAField: BinaryCodable {
        let unknown: UInt8
        let dialogueTab: UInt8
        let subtypeID: UInt8
        let unused2: UInt8
    }
}


