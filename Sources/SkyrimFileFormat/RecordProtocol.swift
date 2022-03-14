// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Bytes
import Foundation
import SWCompression

public struct RecordMetadata: Codable {
    static let propertyName = "_meta"
    static let fileName = "meta.json"
    
    let header: RecordHeader
    let fields: UnpackedFields?
    let fieldOrder: [Tag]?      // TODO: may be able to skip storing fieldOrder for records where all fields are encoded/decoded explicitly
    let originalData: Bytes?
    let children: [RecordProtocol]? // TODO: make this an iterator so that we can defer loading of children

    public enum CodingsKeys: CodingKey {
        case rawFields
        case fieldOrder
    }

    init(type: Tag) {
        self.init(header: .init(type: type))
    }
    
    init(header: RecordHeader, fields: UnpackedFields? = nil, fieldOrder: [Tag]? = nil, originalData: Bytes? = nil, children: [RecordProtocol]? = nil) {
        self.header = header
        self.fields = fields
        self.fieldOrder = fieldOrder
        self.originalData = originalData
        self.children = children
    }
    

    public init(from decoder: Decoder) throws {
        self.header = try RecordHeader(from: decoder)
        let container = try decoder.container(keyedBy: Self.CodingsKeys)
        if let fields = try? container.decode(UnpackedFields.self, forKey: .rawFields) {
            self.fields = fields
        } else {
            self.fields = nil
        }
        
        if let fieldOrder = try? container.decode([Tag].self, forKey: .fieldOrder) {
            self.fieldOrder = fieldOrder
        } else {
            self.fieldOrder = nil
        }
        
        self.originalData = nil
        self.children = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        try header.encode(to: encoder)
        var container = encoder.container(keyedBy: Self.CodingsKeys)
        if let fields = fields {
            try container.encode(fields, forKey: .rawFields)
        }
        if let fieldOrder = fieldOrder {
            try container.encode(fieldOrder, forKey: .fieldOrder)
        }
    }
}

public protocol RecordProtocol: BinaryCodable, CustomStringConvertible {
    static var tag: Tag { get }
    func asJSON(with processor: Processor) throws -> Data
    static func fromJSON(_ data: Data, with processor: Processor) throws -> RecordProtocol
    static var fieldMap: FieldTypeMap { get }
    var _meta: RecordMetadata { get }
}

extension RecordProtocol {
    public var type: Tag { _meta.header.type }
    
    public var header: RecordHeader { _meta.header }

    public var isGroup: Bool { _meta.header.type == GroupRecord.tag }
    
    public var typeAndID: String {
        let suffix: String
        if let id = _meta.header.id, id != 0 {
            suffix = String(format: "[%@:%08X]", _meta.header.label, id)
        } else {
            suffix = "[\(_meta.header.label)]"
        }
        
        return suffix
    }
    
    public var name: String {
        return typeAndID
    }
    
    public var fullName: String {
        if let groupType = header.groupLabel {
            return "Group of \(children.count) \(groupType) records:"
        } else if let namedID = namedID {
            return "\(namedID) \(typeAndID)"
        } else {
            return typeAndID
        }
    }
    
    public var namedID: String? {
        guard let identified = self as? IdentifiedRecord, let id = identified.editorID else { return nil }
        return id
    }

    public func asJSON(with processor: Processor) throws -> Data {
        return try processor.jsonEncoder.encode(self)
    }
    
    public static func fromJSON(_ data: Data, with processor: Processor) throws -> RecordProtocol {
        let decoded = try processor.jsonDecoder.decode(Self.self, from: data)
        return decoded
    }
    
    public var children: [RecordProtocol] { _meta.children ?? [] }
}

extension RecordProtocol {
    var description: String { return "«\(fullName)»" }
}

extension CodingUserInfoKey {
    static var configurationUserInfoKey: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "Configuration")!
    }
}

extension RecordProtocol {
    public func binaryEncode(to encoder: BinaryEncoder) throws {

        
        if let configuration = encoder.userInfo[.configurationUserInfoKey] as? Configuration {
            assert(!isGroup)

            let type = header.type
            let fields = try configuration.fields(forRecord: type)
            let recordEncoder = RecordEncoder(fields: fields, fieldOrder: _meta.fieldOrder ?? [])
            try encode(to: recordEncoder)
            let recordData = recordEncoder.orderedFieldData
            let payloadSize = recordData.count

            try type.binaryEncode(to: encoder)
            if header.isCompressed {
                compressionChannel.log("Compressing data for \(header.label)")
                let compressedData = ZlibArchive.archive(data: recordData)
                let compressedSize = compressedData.count
                let size = compressedSize - RecordHeader.binaryEncodedSize + (isGroup ? 24 : 0)
                try UInt32(size).encode(to: encoder)
                try UInt32(payloadSize).encode(to: encoder)
                try compressedData.encode(to: encoder)
            } else {
                let size = payloadSize - RecordHeader.binaryEncodedSize + (isGroup ? 24 : 0)
                try UInt32(size).encode(to: encoder)
                try recordData.encode(to: encoder)
            }
        }

    }
    
    var hasUnprocessedFields: Bool {
        return (_meta.fields?.count ?? 0) > 0
    }
}

protocol IdentifiedRecord: RecordProtocol {
    var editorID: String? { get }
}
