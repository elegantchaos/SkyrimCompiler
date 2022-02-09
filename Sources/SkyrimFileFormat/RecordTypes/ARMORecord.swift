// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

private extension Tag {
    static let editorID: Self = "EDID"
    static let maleArmour: Self = "MOD2"
    static let femaleArmour: Self = "MOD4"
}

struct ARMORecord: Codable, RecordProtocol {
    static var tag = Tag("ARMO")
    
    let header: UnpackedHeader
    let editorID: String
    let maleArmour: String
    let femaleArmour: String?
    let fields: [UnpackedField]?

    static var fieldMap: FieldMap {
        [
            "EDID": .string("editorID"),
            "MOD2": .string("maleArmour"),
            "MOD4": .string("femaleArmour"),
        ]
    }
    
    static func asJSON(header: UnpackedHeader, fields: DecodedFields, with processor: Processor) throws -> Data {
        let decoder = RecordDecoder(header: header, fields: fields)
        let record = try decoder.decode(ARMORecord.self)
        return try processor.encoder.encode(record)
    }
}


extension ARMORecord: CustomStringConvertible {
    var description: String {
        return "«armour \(editorID)»"
    }
}
