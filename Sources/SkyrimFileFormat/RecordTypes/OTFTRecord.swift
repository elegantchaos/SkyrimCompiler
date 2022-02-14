// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct OTFTRecord: IdentifiedRecord {
    static var tag = Tag("OTFT")
    
    let _header: RecordHeader
    let _fields: UnpackedFields?

    let editorID: String
    let items: SingleFieldArray<FormID>

    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.items, \.items, "INAM"),
    ])
}
