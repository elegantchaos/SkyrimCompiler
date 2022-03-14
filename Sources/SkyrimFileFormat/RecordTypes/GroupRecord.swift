// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Bytes
import Foundation

struct GroupRecord: RecordProtocol {
    static let tag = Tag("GRUP")
    static let fileExtension = "espg"
    
    let _meta: RecordMetadata
    
    init(header: RecordHeader, children: [RecordProtocol]) {
        self._meta = .init(header: header, children: children)
    }

    static var fieldMap = FieldTypeMap()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(_meta.header) // TODO: re-interpret header using group flags?
    }

    func binaryEncode(to encoder: BinaryEncoder) throws {
        assert(isGroup)
        
        let childEncoder = DataEncoder()
        childEncoder.userInfo = encoder.userInfo
        for child in children {
            try child.binaryEncode(to: childEncoder)
        }

        var container = encoder.unkeyedContainer()
        try container.encode(_meta.header.type)
        try container.encode(UInt32(childEncoder.data.count + 24))
        try container.encode(_meta.header) // TODO: re-interpret header using group flags?
        try container.encode(childEncoder.data)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        _meta = .init(header: try container.decode(RecordHeader.self))
    }
}
