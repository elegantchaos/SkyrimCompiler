// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

protocol RecordProtocol: BinaryCodable, CustomStringConvertible {
    static var tag: Tag { get }
    func asJSON(with processor: Processor) throws -> Data
    static func fromJSON(_ data: Data, with processor: Processor) throws -> RecordProtocol
    static var fieldMap: FieldTypeMap { get }
    var _header: RecordHeader { get }
    var _children: [RecordProtocol] { get } // TODO: make this an iterator so that we can defer loading of children
}

extension RecordProtocol {
    var type: Tag { _header.type }
    
    var header: RecordHeader { _header }

    var isGroup: Bool { _header.type == GroupRecord.tag }
    
    var name: String {
        guard let id = _header.id, id != 0 else { return "[\(_header.label)]" }
        return String(format: "[%@:%08X]", _header.label, id)
    }

    func asJSON(with processor: Processor) throws -> Data {
        return try processor.jsonEncoder.encode(self)
    }
    
    static func fromJSON(_ data: Data, with processor: Processor) throws -> RecordProtocol {
        let decoded = try processor.jsonDecoder.decode(Self.self, from: data)
        return decoded
    }
    
    var _children: [RecordProtocol] { [] }
}

extension RecordProtocol {
    var description: String {
        "«\(type)»"
    }
}

extension CodingUserInfoKey {
    static var configurationUserInfoKey: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "Configuration")!
    }
}

extension RecordProtocol {
    func binaryEncode(to encoder: BinaryEncoder) throws {

        
        if let configuration = encoder.userInfo[.configurationUserInfoKey] as? Configuration {
            assert(!isGroup)

            let type = header.type
            let fields = try configuration.fields(forRecord: type)
            let recordEncoder = RecordEncoder(fields: fields)
            try encode(to: recordEncoder)
            let recordData = recordEncoder.data
            let payloadSize = recordData.count

            try type.binaryEncode(to: encoder)
            let size = payloadSize - RecordHeader.binaryEncodedSize + (isGroup ? 24 : 0)
            try UInt32(size).encode(to: encoder)
            try recordData.encode(to: encoder)
        }

    }
    
    var hasUnprocessedFields: Bool {
        guard let partial = self as? PartialRecord else { return false }
        guard let count = partial._fields?.count else { return false }
        return count > 0
    }
}

protocol IdentifiedRecord: RecordProtocol {
    var editorID: String { get }
}

protocol PartialRecord: RecordProtocol {
    var _fields: UnpackedFields? { get }
}
