// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

/// Maps the coding keys for fields to their types
struct FieldTypeMap {
    struct Entry {
        let type: BinaryDecodable.Type // TODO: Codable may be enough here.
        let readKey: Tag
    }
    
    typealias Map = [String:Entry]
    typealias NameMap = [Tag:String]
    
    private let index: Map
    private let tagToName: [Tag:String]
    let tagOrder: [Tag]

    init() {
        index = [:]
        tagToName = [:]
        tagOrder = []
    }
    
    init<K, T>(paths map: [(K, PartialKeyPath<T>, String)]) where K: CodingKey {
        var entries = Map()
        var tagToName = NameMap()
        var tagOrder: [Tag] = []
        
        for (key, path, readKey) in map {
            let t: Any.Type
            if let p = path as? EnclosingType {
                t = type(of: p).baseType
            } else {
                t = type(of: path).valueType
            }

            let readTag = Tag(readKey)
            entries[key.stringValue] = Entry(type: t as! BinaryDecodable.Type, readKey: readTag)
            tagToName[readTag] = key.stringValue
            tagOrder.append(readTag)
        }
    
        self.index = entries
        self.tagToName = tagToName
        self.tagOrder = tagOrder
    }


    func haveMapping(forTag tag: Tag) -> Bool {
        return tagToName[tag] != nil
    }

    func fieldType(forKey key: CodingKey) -> BinaryDecodable.Type? {
        index[key.stringValue]?.type
    }

    func fieldType(forTag tag: Tag) -> BinaryDecodable.Type? {
        guard let name = tagToName[tag] else { return nil }
        return index[name]?.type
    }

    func fieldTag(forKey key: CodingKey) -> Tag? {
        return index[key.stringValue]?.readKey
    }
}
