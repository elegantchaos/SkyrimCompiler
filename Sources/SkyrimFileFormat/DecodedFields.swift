// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

class DecodedFields {
    let spec: FieldTypeMap
    var values: [Tag:[Field]]
    var unprocessed: [Tag:[Field]]
    
    init(_ spec: FieldTypeMap) {
        self.spec = spec
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
            if !spec.haveMapping(forFieldType: key) {
                unprocessed[key] = values[key]
                values.removeValue(forKey: key)
            }
        }
    }
    
    func unpack<T>(_ tag: Tag) throws -> T {
        guard let value = values[tag] as? T else { throw SkyrimFileError.requiredPropertyWrongType }
        return value
    }
}
