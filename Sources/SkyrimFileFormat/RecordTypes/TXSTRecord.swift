// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct TXSTRecord: Codable, IdentifiedRecord {
    static var tag = Tag("TXST")
    
    let _header: RecordHeader
    let _fields: UnpackedFields?

    let editorID: String
    let colorMap: String
    let normalMap: String?
    let mask: String?
    let toneMap: String?
    let detailMap: String?
    let environmentMap: String?
    let multilayer: String?
    let specularMap: String?
    let decalData: DecalData?
    let flags: TextureFlags

    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.colorMap, \.colorMap, "TX00"),
        (.normalMap, \.normalMap, "TX01"),
        (.mask, \.mask, "TX02"),
        (.toneMap, \.toneMap, "TX03"),
        (.detailMap, \.detailMap, "TX04"),
        (.environmentMap, \.environmentMap, "TX05"),
        (.multilayer, \.multilayer, "TX06"),
        (.specularMap, \.specularMap, "TX07"),
        (.decalData, \.decalData, "DODT"),
        (.flags, \.flags, "DNAM"),
    ])
}
