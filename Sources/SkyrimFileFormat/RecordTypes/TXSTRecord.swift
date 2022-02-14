// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct TXSTRecord: Codable, RecordProtocol {
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
    let flags: TextureFlags

    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (CodingKeys.colorMap, \Self.colorMap, "TX00"),
        (CodingKeys.normalMap, \Self.normalMap, "TX01"),
        (CodingKeys.mask, \Self.mask, "TX02"),
        (CodingKeys.toneMap, \Self.toneMap, "TX03"),
        (CodingKeys.detailMap, \Self.detailMap, "TX04"),
        (CodingKeys.environmentMap, \Self.environmentMap, "TX05"),
        (CodingKeys.multilayer, \Self.multilayer, "TX06"),
        (CodingKeys.specularMap, \Self.specularMap, "TX07"),
        (CodingKeys.flags, \Self.flags, "DNAM"),
    ])
    
    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }
}
