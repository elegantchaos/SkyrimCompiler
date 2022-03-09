// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct DIALRecord: IdentifiedRecord {
    static var tag = Tag("DIAL")

    let _meta: RecordMetadata

    let editorID: String?
    let playerDialogue: String
    let priority: Float32
    let owningBranch: FormID?
    let owningQuest: FormID
    let data: DATAField?
    let subtype: UInt32
    let infoCount: UInt32
    
    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.playerDialogue, \.playerDialogue, "FULL"),
        (.priority, \.priority, "PNAM"),
        (.owningBranch, \.owningBranch, "BNAM"),
        (.owningQuest, \.owningQuest, "QNAM"),
        (.playerDialogue, \.playerDialogue, "DATA"),
        (.subtype, \.subtype, "SNAM"),
        (.infoCount, \.infoCount, "TIFC"),

    ])
    
    struct DATAField: BinaryCodable {
        let unknown: UInt8
        let dialogueTab: UInt8
        let subtypeID: UInt8
        let unused2: UInt8
    }
}

struct WString: Codable, RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension WString: BinaryCodable {
    init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        let size = try container.decode(UInt16.self)
        let bytes = try container.decodeArray(of: UInt8.self, count: size)
        guard let string = String(bytes: bytes, encoding: decoder.stringEncoding) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Couldn't decode string as \(decoder.stringEncoding)"))
        }

        self.rawValue = string
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(UInt16(rawValue.count))
        guard let bytes = rawValue.data(using: encoder.stringEncoding) else {
            throw EncodingError.invalidValue(rawValue, .init(codingPath: encoder.codingPath, debugDescription: "Couldn't encode string \(rawValue) as \(encoder.stringEncoding)"))
        }

        try container.encode(bytes)
    }
}
