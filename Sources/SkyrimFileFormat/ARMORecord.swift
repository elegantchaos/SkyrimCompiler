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

enum FieldType {
    case required
    case optional
    case list
}

struct FieldSpec {
    let type: FieldType
    let field: Field.Type
}

class FieldProcessor {
    let spec: [Tag:FieldSpec]
    var values: [Tag:Any]
    var lists: [Tag:[Any]]
    var unprocessed: [Field]
    
    init(_ spec: [Tag:FieldSpec]) {
        self.spec = spec
        self.values = [:]
        self.lists = [:]
        self.unprocessed = []
    }
    
    func add(_ field: Field) throws {
        if let entry = spec[field.header.type] {
            let tag = field.header.type
            guard entry.field == type(of: field) else { throw SkyrimFileError.wrongPropertyType }
            switch entry.type {
                case .required, .optional:
                    guard values[tag] == nil else { throw SkyrimFileError.nonListPropertyRepeated }
                    values[tag] = field.value
                    
                case .list:
                    var list = lists[tag] ?? []
                    list.append(field.value)
                    lists[tag] = list
            }
        } else {
            unprocessed.append(field)
        }
    }
    
    func validate() throws {
        for entry in spec {
            switch entry.value.type {
                case .required:
                    if values[entry.key] == nil { throw SkyrimFileError.requiredPropertyMissing }
                default:
                    break
            }
        }
    }
    
    func unpack<T>(_ tag: Tag) throws -> T {
        guard let value = values[tag] as? T else { throw SkyrimFileError.requiredPropertyWrongType }
        return value
    }
}

class ARMORecord: Record {
    override class var tag: Tag { "ARMO" }
    
    let editorID: String
    let unproccessedFields: [Field]

    static var fieldTypes: FieldsMap = [
        .editorID: StringField.self,
    ]
    
    required init(header: Record.Header, data: Bytes, processor: ProcessorProtocol) async throws {
        var bytes = BytesAsyncSequence(bytes: data)
        
        let fp = FieldProcessor([
            "EDID": .init(type: .required, field: StringField.self)
        ])
        
        for try await field in processor.processor.fields(bytes: &bytes, types: Self.fieldTypes) {
            try fp.add(field)
        }
        
        try fp.validate()
        self.editorID = try fp.unpack("EDID")
        self.unproccessedFields = fp.unprocessed
        
        try await super.init(header: header, data: bytes.bytes, processor: processor)
    }
    
    override var description: String {
        return "«armor \(editorID) - \(String(format: "0x%08X", header.id))»"
    }
}
