// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct RawRecord: RecordProtocol {
    static var tag = Tag("????")

    let _header: RecordHeader
    let _fields: UnpackedFields
    
    init(header: RecordHeader, fields: DecodedFields) throws {
        self._header = header
        self._fields = fields.unproccessedFields
    }
    
    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }

    static var fieldMap = FieldTypeMap()
}

extension RawRecord: CustomStringConvertible {
    var description: String {
        let fieldDescription = Set(_fields.keys).joined(separator: ", ")
        return "«\(header.type), fields:\(fieldDescription)»"
    }
}
