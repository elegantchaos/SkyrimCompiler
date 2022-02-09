// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

struct ARMORecord: Codable, RecordProtocol {
    static var tag = Tag("ARMO")
    
    let header: RecordHeader
    let editorID: String
    let maleArmour: String
    let femaleArmour: String?
    let fullName: String?
    let fields: [UnpackedField]?

    static var fieldMap: FieldMap {
        [
            "EDID": .string("editorID"),
            "MOD2": .string("maleArmour"),
            "MOD4": .string("femaleArmour"),
            "FULL": .string("fullName")
        ]
    }
    
    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }
}


extension ARMORecord: CustomStringConvertible {
    var description: String {
        return "«armour \(fullName ?? editorID)»"
    }
}
