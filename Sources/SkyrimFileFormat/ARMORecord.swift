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
    
    let header: UnpackedHeader
    let editorID: String
    let fields: [UnpackedField]
    
    init(header: RecordHeader, fields: FieldProcessor) throws {
        self.header = UnpackedHeader(header)
        self.fields = fields.unprocessed.map { UnpackedField($0) }
        self.editorID = fields.values[.editorID] as! String
    }

    static func unpack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        let record = try ARMORecord(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
}
