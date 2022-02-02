// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

typealias RecordMap = [Tag:Record.Type]
typealias FieldsMap = [Tag:Field.Type]

struct Configuration {
    static let defaultRecords = [Group.self, TES4Record.self]
    static let defaultRecordMap = RecordMap(uniqueKeysWithValues: defaultRecords.map { ($0.tag, $0) })
    
    static let defaultFields = [HEDRField.self]
    static let defaultFieldMap: FieldsMap = FieldsMap(uniqueKeysWithValues: defaultFields.map { ($0.tag, $0) })

    internal init(records: RecordMap = Self.defaultRecordMap, fields: FieldsMap = Self.defaultFieldMap) {
        self.records = records
        self.fields = fields
    }
    
    let records: RecordMap
    let fields: FieldsMap
}

