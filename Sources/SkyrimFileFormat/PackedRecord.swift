// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct PackedRecord: Encodable, RecordProperties {
    let header: UnpackedHeader
    let fields: [UnpackedField]
    
    static var tag: Tag { "???" }
    
    init(header: RecordHeader, fields: FieldProcessor) throws {
        self.header = UnpackedHeader(header)
        self.fields = fields.unprocessed.map { UnpackedField($0) }
    }
    
    var containsRawFields: Bool {
        return false
    }
    
    static func unpack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        let record = try PackedRecord(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
}
