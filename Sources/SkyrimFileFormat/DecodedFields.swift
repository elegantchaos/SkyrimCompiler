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
//    let type: FieldType
    let field: Decodable.Type
    let name: String
}

struct FieldMapEntry: Codable {
    let name: String
    let tag: String
    let type: String
//    let role: FieldType
}

typealias FieldMapEntries = [FieldMapEntry]

typealias FieldsMap = [Tag:FieldSpec]


class DecodedFields {
    let spec: FieldTypeMap
    var values: [Tag:[Field]]
    
    init(_ spec: FieldTypeMap) {
        self.spec = spec
        self.values = [:]
    }
    
    func add(_ field: Field) throws {
        let tag = field.header.type
        var list = (values[tag]) ?? []
        list.append(field)
        values[tag] = list
    }
    
    func unpack<T>(_ tag: Tag) throws -> T {
        guard let value = values[tag] as? T else { throw SkyrimFileError.requiredPropertyWrongType }
        return value
    }
}
