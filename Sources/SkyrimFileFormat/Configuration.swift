// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

protocol RecordProtocol: Codable {
    static var tag: Tag { get }
    static func asJSON(header: RecordHeader, fields: DecodedFields, with processor: Processor) throws -> Data
    var header: UnpackedHeader { get }
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
            if let fieldClass = fieldClasses[entry.type] {
                map[Tag(entry.tag)] = FieldSpec(type: entry.role, field: fieldClass, name: entry.name)
            } else {
                print("Unknown field class \(entry.type)")
                print("nblah")
            }
        }
        
        return map
    }
}
