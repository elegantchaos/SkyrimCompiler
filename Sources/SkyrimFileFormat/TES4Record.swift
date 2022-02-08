// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Coercion
import Foundation

private extension Tag {
    static let header: Self = "HEDR"
    static let author: Self = "CNAM"
    static let description: Self = "SNAM"
    static let master: Self = "MAST"
    static let tagifiedStringCount: Self = "INTV"
    static let unknownCounter: Self = "INCC"
    static let unusedData: Self = "DATA"
}

struct TES4Record: Encodable, RecordProperties {
    static var tag: Tag { "TES4" }
    
    internal init(header: RecordHeader, fields: FieldProcessor) throws {
        guard let headerField = fields.values[.header] as? FieldHEDR else { throw SkyrimFileError.badTag }

        self.header = UnpackedHeader(header)
        self.fields = fields.unprocessed.count > 0 ? fields.unprocessed.map { UnpackedField($0) } : nil
        self.version = headerField.version
        self.count = UInt(headerField.number)
        self.nextID = UInt(headerField.nextID)
        self.desc = fields.values[.description] as! String
        self.author = fields.values[.author] as! String
        self.masters = fields.lists[.master] as! [String]
        self.tagifiedStringCount = fields.values[asUInt: .tagifiedStringCount]!
        self.unknownCounter = fields.values[asUInt: .unknownCounter]
    }
    
    let header: UnpackedHeader
    let version: Float
    let count: UInt
    let nextID: UInt
    let desc: String
    let author: String
    let masters: [String]
    let tagifiedStringCount: UInt
    let unknownCounter: UInt?
    let fields: [UnpackedField]?

    static func unpack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        let record = try TES4Record(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
}

