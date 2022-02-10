// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

struct FieldSpec {
    let field: Decodable.Type
    let name: String
}

struct FieldMapEntry: Codable {
    let name: String
    let tag: String
    let type: String
}

typealias FieldMapEntries = [FieldMapEntry]

typealias FieldsMap = [Tag:FieldSpec]


class DecodedFields {
    let map: FieldTypeMap
    private var values: [Tag:[Field]]
    private var unprocessed: [Tag:[Field]]

    init(_ spec: FieldTypeMap) {
        self.map = spec
        self.values = [:]
        self.unprocessed = [:]
    }
    
    func add(_ field: Field) throws {
        let tag = field.header.type
        var list = (values[tag]) ?? []
        list.append(field)
        values[tag] = list
    }

    func moveUnprocesed() {
        let keys = values.keys
        for key in keys {
            if !map.haveMapping(forTag: key) {
                unprocessed[key] = values[key]
                values.removeValue(forKey: key)
            }
        }
    }
    
    func unpack<T>(_ tag: Tag) throws -> T {
        guard let value = values[tag] as? T else { throw SkyrimFileError.requiredPropertyWrongType }
        return value
    }
    
    func values(forKey key: CodingKey) -> [Field]? {
        guard let tag = map.fieldTag(forKey: key) else { return nil }
        return values[tag]
    }
    
    var haveUnprocessedFields: Bool {
        unprocessed.count > 0
    }
    
    var unproccessedFields: UnpackedFields {
        let keysAndValues = unprocessed.map({ ($0.key.description, $0.value.map({ $0.encodedValue})) })
        return UnpackedFields(uniqueKeysWithValues: keysAndValues)
        
    }
}
