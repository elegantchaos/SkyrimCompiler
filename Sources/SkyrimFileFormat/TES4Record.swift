// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

extension Tag {
    static let header: Self = "HEDR"
    
}
class TES4Record: Record {
    override class var tag: Tag { "TES4" }
    
    let version: Float
    let count: UInt
    let nextID: UInt
    
    static var fieldTypes: FieldsMap = [
        .header: HEDRField.self,
        "CNAM": StringField.self,
        "SNAM": StringField.self
    ]
    
    required init(header: Record.Header, data: Bytes, processor: ProcessorProtocol) async throws {
        var bytes = BytesAsyncSequence(bytes: data)
        var headerField: HEDRField?
        
        for try await field in processor.processor.fields(bytes: &bytes) {
            switch field.header.type {
                case .header:
                    headerField = field as? HEDRField
                    
                default:
                    break
            }
        }

        guard let headerField = headerField else { throw SkyrimFileError.badTag }
        self.version = headerField.version
        self.count = UInt(headerField.number)
        self.nextID = UInt(headerField.nextID)

        try await super.init(header: header, data: bytes.bytes, processor: processor)
    }
}
