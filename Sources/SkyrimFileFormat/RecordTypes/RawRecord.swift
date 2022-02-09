// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct RawRecord: RecordProtocol {
    static var tag = Tag("????")

    let header: UnpackedHeader
    let fields: [UnpackedField]
    
    init(header: UnpackedHeader, fields: DecodedFields) throws {
        self.header = header
        self.fields = fields.values.flatMap({ $0.value }).map({ UnpackedField($0) })
    }
    
    static func asJSON(header: UnpackedHeader, fields: DecodedFields, with processor: Processor) throws -> Data {
        let record = try RawRecord(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
    
    static var fieldMap: FieldMap {
        [:]
    }
}

extension RawRecord: CustomStringConvertible {
    var description: String {
        let fieldDescription = Set(fields.map({ $0.type.description })).joined(separator: ", ")
        return "«\(header.type), fields:\(fieldDescription)»"
    }
}
