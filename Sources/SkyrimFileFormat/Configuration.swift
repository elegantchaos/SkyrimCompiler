// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol RecordProperties {
    static var tag: Tag { get }
    init(header: RecordHeader, fields: FieldProcessor) throws
    static func pack(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data
}

typealias RecordMap = [Tag:RecordProperties.Type]
typealias FieldClassesMap = [String:Field.Type]

struct Configuration {
    static let defaultRecords: [RecordProperties.Type] = [
        ARMORecord.self,
        TES4Record.self
    ]
    
    static let defaultFields = [
        HEDRField.self,
        StringField.self
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
            if let fieldClass = fieldClasses["\(entry.type)Field"] {
                map[Tag(entry.tag)] = FieldSpec(type: entry.role, field: fieldClass)
            } else {
                print("Unknown field class \(entry.type)")
            }
        }
        
        return map
    }
}
