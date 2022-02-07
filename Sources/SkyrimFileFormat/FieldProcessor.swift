// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

enum FieldType: String, Codable {
    case required
    case optional
    case list
}

struct FieldSpec {
    let type: FieldType
    let field: Field.Type
}

struct FieldMapEntry: Codable {
    let name: String
    let tag: String
    let type: String
    let role: FieldType
}

typealias FieldMapEntries = [FieldMapEntry]

typealias FieldsMap = [Tag:FieldSpec]

extension FieldsMap {
    static func map(named name: String, configuration: Configuration) throws -> FieldsMap {
        let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fields")!
        let json = try Data(contentsOf: url)
        let entries: FieldMapEntries
        do {
            entries = try JSONDecoder().decode(FieldMapEntries.self, from: json)
        } catch {
            print(error)
            throw error
        }
        var map = FieldsMap()
        for entry in entries {
            if let fieldClass = configuration.fields["\(entry.type)Field"] {
                map[Tag(entry.tag)] = FieldSpec(type: entry.role, field: fieldClass)
            } else {
                print("Unknown field class \(entry.type)")
            }
        }
        
        return map
    }
}

class FieldProcessor {
    let spec: [Tag:FieldSpec]
    var values: [Tag:Any]
    var lists: [Tag:[Any]]
    var unprocessed: [Field]
    
    init(_ spec: FieldsMap) {
        self.spec = spec
        self.values = [:]
        self.lists = [:]
        self.unprocessed = []
    }
    
    func process(data: Bytes, processor: ProcessorProtocol) async throws -> Bytes {
        var bytes = BytesAsyncSequence(bytes: data)
        
        for try await field in processor.processor.fields(bytes: &bytes, types: spec) {
            try add(field)
        }
        
        try validate()
        return bytes.bytes
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
