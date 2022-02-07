// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct PackedRecord: Encodable, RecordProperties {
    let header: PackedHeader
    let fields: [PackedField]
    
    static var tag: Tag { "???" }
    
    init(header: RecordHeader, fields: FieldProcessor) throws {
        self.header = PackedHeader(header)
        self.fields = fields.unprocessed.map { PackedField($0) }
    }
    
    var containsRawFields: Bool {
        return false
    }
    
    static func pack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        let record = try PackedRecord(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
}
