// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Maps the coding keys for fields to their types
struct FieldTypeMap {
    typealias Map = [Tag:Decodable.Type]
    
    private let byTag: Map
    
    init() {
        byTag = [:]
    }
    
    init<K, T>(paths map: [K:PartialKeyPath<T>]) where K: CodingKey, K: RawRepresentable, K.RawValue == String {
        var entries: Map = [:]
        for (key, path) in map {
            let t: Decodable.Type
            if let p = path as? EnclosingType {
                t = type(of: p).baseType as! Decodable.Type
            } else {
                t = type(of: path).valueType as! Decodable.Type
            }

            entries[Tag(key.rawValue)] = t
        }
    
        self.byTag = entries
    }

    func valueType(forFieldType type: Tag) -> Decodable.Type? {
        return byTag[type]
    }
    
    func haveMapping(forFieldType type: Tag) -> Bool {
        return byTag[type] != nil
    }
}
