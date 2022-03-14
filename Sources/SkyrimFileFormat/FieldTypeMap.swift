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
        let groupWithNext: Bool
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
    
    struct FieldSpec<K: CodingKey, T> {
        let codingKey: K
        let property: PartialKeyPath<T>
        let tag: Tag
        let groupWithNext: Bool

        internal init(_ key: K, _ path: PartialKeyPath<T>, _ tag: Tag, groupWithNext: Bool = false) {
            self.codingKey = key
            self.property = path
            self.tag = tag
            self.groupWithNext = groupWithNext
        }
    }
    
    init<K, T>(fields map: [FieldSpec<K, T>]) where K: CodingKey {
        var entries = Map()
        var tagToName = NameMap()
        var tagOrder: [Tag] = []
        
        for spec in map {
            let t: Any.Type
            if let p = spec.property as? EnclosingType {
                t = type(of: p).baseType
            } else {
                t = type(of: spec.property).valueType
            }

            entries[spec.codingKey.stringValue] = Entry(type: t as! BinaryDecodable.Type, readKey: spec.tag, groupWithNext: spec.groupWithNext)
            tagToName[spec.tag] = spec.codingKey.stringValue
            tagOrder.append(spec.tag)
        }
    
        self.index = entries
        self.tagToName = tagToName
        self.tagOrder = tagOrder
    }
    
    init<K, T>(paths map: [(K, PartialKeyPath<T>, String)]) where K: CodingKey {
        let specs: [FieldSpec<K, T>] = map.map{ .init($0.0, $0.1, Tag($0.2), groupWithNext: false)}
        self.init(fields: specs)
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
