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
    let name: String
}

struct FieldMapEntry: Codable {
    let name: String
    let tag: String
    let type: String
    let role: FieldType
}

typealias FieldMapEntries = [FieldMapEntry]

typealias FieldsMap = [Tag:FieldSpec]


class FieldProcessor {
    let spec: [Tag:FieldSpec]
    var values: [Tag:Any]
    var unprocessed: [Field]
    
    init(_ spec: FieldsMap) {
        self.spec = spec
        self.values = [:]
        self.unprocessed = []
    }
    
    func process(data: Bytes, processor: Processor) async throws {
        var bytes = BytesAsyncSequence(bytes: data)
        
        let fields = processor.fields(bytes: &bytes, types: spec)
        for try await field in fields {
            try add(field)
        }
        
        try validate()
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
                    var list = (values[tag] as? [Any]) ?? []
                    list.append(field.value)
                    values[tag] = list
            }
        } else {
            unprocessed.append(field)
        }
    }
    
    func validate() throws {
        for entry in spec {
            switch entry.value.type {
                case .required:
                    if values[entry.key] == nil {
                        throw SkyrimFileError.requiredPropertyMissing
                        
                    }
                default:
                    break
            }
        }
    }
    
    func unpack<T>(_ tag: Tag) throws -> T {
        guard let value = values[tag] as? T else { throw SkyrimFileError.requiredPropertyWrongType }
        return value
    }
    
    func tag(for field: String) -> Tag? {
        for f in spec {
            if f.value.name == field {
                return f.key
            }
        }
        
        return nil
    }

    func extract<A,B>(_ key: WritableKeyPath<A,Optional<B>>, from: inout A) {
        if let tag = tag(for: "\(key)") {
            from[keyPath: key] = values[tag] as? B
        }
    }

    func extract<A,B>(_ key: WritableKeyPath<A,B>, from: inout A) {
        if let tag = tag(for: "\(key)") {
            from[keyPath: key] = values[tag] as! B
        }
    }
    
    func extract2<A,B>(_ key: KeyPath<A,B>) -> B {
        let tag = tag(for: "\(key)")!
        return values[tag] as! B
    }

    func extract3<B>(_ key: String) -> B {
        let tag = tag(for: key)!
        return values[tag] as! B
    }

}
