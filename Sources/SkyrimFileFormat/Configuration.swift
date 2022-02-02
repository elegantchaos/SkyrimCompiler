// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

typealias RecordMap = [Tag:Record.Type]
typealias FieldsMap = [Tag:Field.Type]

struct Configuration {
    static let defaultRecords = [
        Group.self,
        TES4Record.self,
        ARMORecord.self
    ]
    
    static let defaultRecordMap = RecordMap(uniqueKeysWithValues: defaultRecords.map { ($0.tag, $0) })

    let records: RecordMap

    internal init(records: RecordMap = Self.defaultRecordMap) {
        self.records = records
    }
    
}

