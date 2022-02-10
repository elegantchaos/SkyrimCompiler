// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation


typealias RecordMap = [Tag:RecordProtocol.Type]

struct Configuration {
    static let defaultRecords: [RecordProtocol.Type] = [
        ARMORecord.self,
        TES4Record.self
    ]
    
    static let defaultRecordMap = RecordMap(uniqueKeysWithValues: defaultRecords.map { ($0.tag, $0) })
    static let defaultFieldsMap = FieldTypeMap()

    let records: RecordMap
    
    internal init(records: RecordMap = Self.defaultRecordMap /*, fields: FieldClassesMap = Self.defaultFieldClassesMap*/) {
        self.records = records
    }
    
    func recordClass(for type: Tag) -> RecordProtocol.Type {
        records[type] ?? RawRecord.self
    }
    
    func fields(forRecord type: Tag) throws -> FieldTypeMap {
        guard let kind = records[type] else { return Self.defaultFieldsMap }
        return kind.fieldMap
    }
}
