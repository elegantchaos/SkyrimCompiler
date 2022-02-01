// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

typealias RecordMap = [Tag:Record.Type]
typealias FieldsMap = [Tag:Field.Type]

struct Configuration {
    static let defaultRecordMap: RecordMap = [
        .group: Group.self,
        .tes4: TES4Record.self
    ]
    
    static let defaultFieldMap: FieldsMap = [:]

    internal init(records: RecordMap = Self.defaultRecordMap, fields: FieldsMap = Self.defaultFieldMap) {
        self.records = records
        self.fields = fields
    }
    
    let records: RecordMap
    let fields: FieldsMap
}

