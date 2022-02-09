// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct FieldMap: ExpressibleByDictionaryLiteral {
    struct Entry {
        let name: String
        let type: Decodable.Type
        
        init(_ name: String, _ type: Decodable.Type) {
            self.name = name
            self.type = type
        }
        
        static func string(_ name: String) -> Entry {
            return .init(name, String.self)
        }
    }
    

    let byTag: [Tag:Entry]
    
    init(dictionaryLiteral elements: (Tag, Entry)...) {
        var byTag: [Tag:Entry] = [:]
        
        for (tag, entry) in elements {
            byTag[tag] = entry
        }

        self.byTag = byTag
    }
    
    init(_ entries: [Tag:Entry]) {
        
        var byName: [String:Tag] = [:]
        for (tag, entry) in entries {
            byName[entry.name] = tag
        }

        self.byTag = entries
    }
    
    init<T>(paths map: [Tag:PartialKeyPath<T>]) {
        var entries: [Tag:FieldMap.Entry] = [:]
        for (key, path) in map {
            print(type(of: path))
            let t: Any.Type
            if let p = path as? EnclosingType {
                t = type(of: p).baseType
            } else {
                t = type(of: path).valueType
            }

            entries[key] = .init("\(path)", t as! Decodable.Type)
        }
    
        self.init(entries)
    }
}

protocol RecordProtocol: Codable {
    static var tag: Tag { get }
    func asJSON(with processor: Processor) throws -> Data
    static var fieldMap: FieldMap { get }
    var header: RecordHeader { get }
}

protocol FieldProtocol {
    static func unpack(header: Field.Header, data: Bytes, with processor: Processor) throws -> Any
}

typealias RecordMap = [Tag:RecordProtocol.Type]
typealias FieldClassesMap = [String:Decodable.Type]

struct Configuration {
    static let defaultRecords: [RecordProtocol.Type] = [
        ARMORecord.self,
        TES4Record.self
    ]
    
    static let defaultFields: [Decodable.Type] = [
        TES4Header.self,
        String.self,
        UInt32.self,
        UInt64.self,
        Float.self
    ]
    
    static let defaultRecordMap = RecordMap(uniqueKeysWithValues: defaultRecords.map { ($0.tag, $0) })
    static let defaultFieldClassesMap = FieldClassesMap(uniqueKeysWithValues: defaultFields.map { (String(describing: $0), $0) })

    let records: RecordMap
    let fieldClasses: FieldClassesMap
    let defaultFieldsMap: FieldMap = [:]
    
    internal init(records: RecordMap = Self.defaultRecordMap, fields: FieldClassesMap = Self.defaultFieldClassesMap) {
        self.records = records
        self.fieldClasses = fields
    }
    
    func recordClass(for type: Tag) -> RecordProtocol.Type {
        records[type] ?? RawRecord.self
    }
    
    func fields(forRecord type: Tag) throws -> FieldMap {
        guard let kind = records[type] else { return defaultFieldsMap }
        return kind.fieldMap
    }
}
