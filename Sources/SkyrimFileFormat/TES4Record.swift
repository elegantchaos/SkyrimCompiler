// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

private extension Tag {
    static let header: Self = "HEDR"
    static let author: Self = "CNAM"
    static let description: Self = "SNAM"
    static let master: Self = "MAST"
}

struct TES4PackedRecord: Encodable, RecordProperties {
    static var tag: Tag { "TES4" }
    
    internal init(header: RecordHeader, fields: FieldProcessor) throws {
        guard let headerField = fields.values[.header] as? HEDRField else { throw SkyrimFileError.badTag }

        self.header = PackedHeader(header)
        self.fields = fields.unprocessed.map { PackedField($0) }
        self.version = headerField.version
        self.count = UInt(headerField.number)
        self.nextID = UInt(headerField.nextID)
        self.desc = fields.values[.description] as! String
        self.author = fields.values[.author] as! String
        self.masters = fields.lists[.master] as! [String]
    }
    
    let header: PackedHeader
    let version: Float
    let count: UInt
    let nextID: UInt
    let desc: String
    let author: String
    let masters: [String]
    let fields: [PackedField]
    
    static func pack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        let record = try TES4PackedRecord(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
}

