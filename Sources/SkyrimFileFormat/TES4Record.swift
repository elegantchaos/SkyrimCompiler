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

class TES4Record: Record {
    override class var tag: Tag { "TES4" }
    
    let version: Float
    let count: UInt
    let nextID: UInt
    let desc: String
    let author: String
    let masters: [String]
    let unproccessedFields: [Field]

    static var fieldTypes: FieldsMap = [
        .header: HEDRField.self,
        .author: StringField.self,
        .description: StringField.self,
        .master: StringField.self
    ]
    
    required init(header: Record.Header, data: Bytes, processor: ProcessorProtocol) async throws {
        var bytes = BytesAsyncSequence(bytes: data)
        var headerField: HEDRField?
        var descField: StringField?
        var authorField: StringField?
        var masters: [String] = []
        var unprocessed: [Field] = []
        for try await field in processor.processor.fields(bytes: &bytes, types: Self.fieldTypes) {
            print(field)
            switch field.header.type {
                case .header: headerField = field as? HEDRField
                case .author: authorField = field as? StringField
                case .description: descField = field as? StringField
                case .master: masters.append((field as? StringField)?.string ?? "")
                default: unprocessed.append(field)
            }
        }

        guard let headerField = headerField else { throw SkyrimFileError.badTag }
        self.version = headerField.version
        self.count = UInt(headerField.number)
        self.nextID = UInt(headerField.nextID)
        self.author = authorField?.string ?? ""
        self.desc = descField?.string ?? ""
        self.masters = masters
        self.unproccessedFields = unprocessed
        
        try await super.init(header: header, data: bytes.bytes, processor: processor)
    }
}
