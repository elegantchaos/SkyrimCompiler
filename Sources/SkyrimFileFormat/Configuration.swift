// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Bytes
import Foundation


protocol FieldProtocol {
    static func unpack(header: Field.Header, data: Bytes, with processor: Processor) throws -> Any
}

typealias RecordMap = [Tag:RecordProtocol.Type]

struct Configuration {
    let records: RecordMap
    
    internal init(records: [RecordProtocol.Type]) {
        self.records = RecordMap(uniqueKeysWithValues: records.map { ($0.tag, $0) })
    }
    
    func recordClass(for type: Tag) -> RecordProtocol.Type {
        records[type] ?? RawRecord.self
    }
    
    func fields(forRecord type: Tag) throws -> FieldTypeMap {
        guard let kind = records[type] else { return Self.defaultFieldsMap }
        return kind.fieldMap
    }

    static let defaultFieldsMap = FieldTypeMap()

    static let defaultConfiguration = Configuration(records: [
        ARMORecord.self,
        ARMARecord.self,
        DIALRecord.self,
        INFORecord.self,
        LVLIRecord.self,
        OTFTRecord.self,
        QUSTRecord.self,
        TES4Record.self,
        TXSTRecord.self
    ])

}

