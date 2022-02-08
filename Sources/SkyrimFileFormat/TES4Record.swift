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

struct HEDR: Codable {
    let version: Float32
    let number: UInt32
    let nextID: UInt32
}

struct TES4Record: Codable, RecordProtocol {
    static var tag: Tag { "TES4" }
    
    internal init(header: RecordHeader, fields: FieldProcessor) throws {
        guard let headerField = fields.values[.header] as? FieldHEDR else { throw SkyrimFileError.badTag }

        self.header = UnpackedHeader(header)
        self.fields = fields.unprocessed.count > 0 ? fields.unprocessed.map { UnpackedField($0) } : nil
        self.info = HEDR(version: headerField.version, number: headerField.number, nextID: headerField.nextID)
//        self.version = headerField.version
//        self.count = UInt(headerField.number)
//        self.nextID = UInt(headerField.nextID)
        self.desc = fields.values[.description] as! String
        self.author = fields.values[.author] as! String
        self.masters = fields.values[.master] as! [String]
        self.tagifiedStringCount = UInt32(fields.values[asUInt: .tagifiedStringCount]!)
        self.unknownCounter = fields.values[asUInt: .unknownCounter]
//        fields.extract(\TES4Record.tagifiedStringCount, from: &self)
//
//        tagifiedStringCount = fields.extract2(\TES4Record.tagifiedStringCount)
//
//        let m = Mirror(reflecting: self)
//        for element in m.children {
//            element.value = fields.extract3(element.label!)
//        }
    }
    
    let header: UnpackedHeader
    let info: HEDR
//    let version: Float
//    let count: UInt
//    let nextID: UInt
    let desc: String
    let author: String
    let masters: [String]
    let tagifiedStringCount: UInt32
    let unknownCounter: UInt?
    let fields: [UnpackedField]?

    static func unpack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        let decoder = RecordDecoder(header: header, fields: fields)
        let record = try decoder.decode(TES4Record.self)
//        let record = try TES4Record(header: header, fields: fields)
        return try processor.encoder.encode(record)
    }
}

