// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation
import SWCompression

struct RecordMetadata: Codable {
    static let propertyName = "_meta"

    let header: RecordHeader
    let fields: UnpackedFields?
    let originalData: Data?
    let children: [RecordProtocol]? // TODO: make this an iterator so that we can defer loading of children

    public enum CodingsKeys: CodingKey {
        case rawFields
    }

    init(type: Tag) {
        self.init(header: .init(type: type))
    }
    
    init(header: RecordHeader, fields: UnpackedFields? = nil, originalData: Data? = nil, children: [RecordProtocol]? = nil) {
        self.header = header
        self.fields = fields
        self.originalData = originalData
        self.children = children
    }
    

    init(from decoder: Decoder) throws {
        self.header = try RecordHeader(from: decoder)
        let container = try decoder.container(keyedBy: Self.CodingsKeys)
        if let fields = try? container.decode(UnpackedFields.self, forKey: .rawFields) {
            self.fields = fields
        } else {
            self.fields = nil
        }
        
        self.originalData = nil
        self.children = nil
    }
    
    func encode(to encoder: Encoder) throws {
        try header.encode(to: encoder)
        if let fields = fields {
            var container = encoder.container(keyedBy: Self.CodingsKeys)
            try container.encode(fields, forKey: .rawFields)
        }
    }
}

protocol RecordProtocol: BinaryCodable, CustomStringConvertible {
    static var tag: Tag { get }
    func asJSON(with processor: Processor) throws -> Data
    static func fromJSON(_ data: Data, with processor: Processor) throws -> RecordProtocol
    static var fieldMap: FieldTypeMap { get }
    var _meta: RecordMetadata { get }
}

extension RecordProtocol {
    var type: Tag { _meta.header.type }
    
    var header: RecordHeader { _meta.header }

    var isGroup: Bool { _meta.header.type == GroupRecord.tag }
    
    var name: String {
        guard let id = _meta.header.id, id != 0 else { return "[\(_meta.header.label)]" }
        return String(format: "[%@:%08X]", _meta.header.label, id)
    }

    func asJSON(with processor: Processor) throws -> Data {
        return try processor.jsonEncoder.encode(self)
    }
    
    static func fromJSON(_ data: Data, with processor: Processor) throws -> RecordProtocol {
        let decoded = try processor.jsonDecoder.decode(Self.self, from: data)
        return decoded
    }
    
    var _children: [RecordProtocol] { _meta.children ?? [] }
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
    var editorID: String { get }
}
