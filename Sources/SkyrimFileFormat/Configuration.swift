// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

protocol RecordProtocol {
    static var tag: Tag { get }
    init(header: RecordHeader, fields: FieldProcessor) throws
    static func unpack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data
}

protocol FieldProtocol {
    static func unpack(header: Field.Header, data: Bytes, with processor: Processor) throws -> Any
}

typealias RecordMap = [Tag:RecordProtocol.Type]
typealias FieldClassesMap = [String:FieldProtocol.Type]

struct Configuration {
    static let defaultRecords: [RecordProtocol.Type] = [
        ARMORecord.self,
        TES4Record.self
    ]
    
    static let defaultFields: [FieldProtocol.Type] = [
        FieldHEDR.self,
        FieldString.self,
        FieldInt<UInt32>.self,
        FieldInt<UInt64>.self
    ]
    
    static let defaultRecordMap = RecordMap(uniqueKeysWithValues: defaultRecords.map { ($0.tag, $0) })
    static let defaultFieldClassesMap = FieldClassesMap(uniqueKeysWithValues: defaultFields.map { (String(describing: $0), $0) })

    let records: RecordMap
    let fieldClasses: FieldClassesMap
    let defaultFieldsMap = FieldsMap()
    
    internal init(records: RecordMap = Self.defaultRecordMap, fields: FieldClassesMap = Self.defaultFieldClassesMap) {
        self.records = records
        self.fieldClasses = fields
    }
    
    func fields(forRecord name: String) throws -> FieldsMap {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Records") else {
            return defaultFieldsMap
        }
        
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
            if let fieldClass = fieldClasses["Field\(entry.type)"] {
                map[Tag(entry.tag)] = FieldSpec(type: entry.role, field: fieldClass, name: entry.name)
            } else {
                print("Unknown field class \(entry.type)")
            }
        }
        
        return map
    }
}
