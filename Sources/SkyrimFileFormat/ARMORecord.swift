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

class ARMORecord: Record {
    override class var tag: Tag { "ARMO" }
    
    let editorID: String
    let unproccessedFields: [Field]

//    static var fieldTypes: FieldsMap = [
//        .editorID: .init(type: .required, field: StringField.self)
//    ]
    
    required init(header: Record.Header, data: Bytes, processor: ProcessorProtocol) async throws {
        let fp = FieldProcessor(try .map(named: "ARMORecord", configuration: processor.configuration))
        let remainder = try await fp.process(data: data, processor: processor)

        self.editorID = try fp.unpack(.editorID)
        self.unproccessedFields = fp.unprocessed
        
        try await super.init(header: header, data: remainder, processor: processor)
    }
    
    override var description: String {
        return "«armor \(editorID) - \(String(format: "0x%08X", header.id))»"
    }
}
