// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct RawRecord: RecordProtocol {
    static var tag = Tag("????")

    let header: RecordHeader
    let fields: [UnpackedField]
    
    init(header: RecordHeader, fields: DecodedFields) throws {
        self.header = header
        self.fields = fields.values.flatMap({ $0.value }).map({ UnpackedField($0) })
    }
    
    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }

    static var fieldMap = FieldTypeMap()
}

extension RawRecord: CustomStringConvertible {
    var description: String {
        let fieldDescription = Set(fields.map({ $0.type.description })).joined(separator: ", ")
        return "«\(header.type), fields:\(fieldDescription)»"
    }
}
