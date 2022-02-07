// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

private extension Tag {
    static let editorID: Self = "EDID"
}

struct ARMORecord: Encodable, RecordProperties {
    static var tag: Tag { "ARMO" }
    
    let header: PackedHeader
    let editorID: String
    let fields: [PackedField]
    
    init(header: RecordHeader, fields: FieldProcessor) throws {
        self.header = PackedHeader(header)
        self.fields = fields.unprocessed.map { PackedField($0) }
        self.editorID = fields.values[.editorID] as! String
    }

    static func pack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        let record = try ARMORecord(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
}
