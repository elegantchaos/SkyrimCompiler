// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct RawRecord: RecordProtocol {
    static var tag = Tag("????")

    let _meta: RecordMetadata
    
    init(header: RecordHeader, fields: DecodedFields) throws {
        self._meta = .init(header: header, fields: fields.unproccessedFields)
    }

    static var fieldMap = FieldTypeMap()
}

extension RawRecord: CustomStringConvertible {
    var description: String {
        let fields = _meta.fields ?? [:]
        let fieldDescription = Set(fields.keys).joined(separator: ", ")
        return "«\(header.type), fields:\(fieldDescription)»"
    }
}
