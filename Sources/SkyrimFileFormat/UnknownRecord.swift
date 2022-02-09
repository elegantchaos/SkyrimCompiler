// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct UnknownRecord: RecordProtocol {
    let header: UnpackedHeader
    let fields: [UnpackedField]
    
    static var tag: Tag { "???" }
    
    init(header: RecordHeader, fields: DecodedFields) throws {
        self.header = UnpackedHeader(header)
        self.fields = fields.values.flatMap({ $0.value }).map({ UnpackedField($0) })
    }
    
    var containsRawFields: Bool {
        return false
    }
    
    static func asJSON(header: RecordHeader, fields: DecodedFields, with processor: Processor) throws -> Data {
        let record = try UnknownRecord(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
}
