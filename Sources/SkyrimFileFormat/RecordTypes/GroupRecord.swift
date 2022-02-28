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
    
    let _header: RecordHeader
    let _children: [RecordProtocol]
    
    init(header: RecordHeader, children: [RecordProtocol]) {
        self._header = header
        self._children = children
    }

    static var fieldMap = FieldTypeMap()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(_header)
    }

    func binaryEncode(to encoder: BinaryEncoder) throws {
        assert(isGroup)
        
        let childEncoder = DataEncoder()
        childEncoder.userInfo = encoder.userInfo
        for child in _children {
            try child.binaryEncode(to: childEncoder)
        }

        var container = encoder.unkeyedContainer()
        try container.encode(_header.type)
        try container.encode(UInt32(childEncoder.data.count + 24))
        try container.encode(_header)
        try container.encode(childEncoder.data)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        _header = try container.decode(RecordHeader.self)
        _children = []
    }
}

extension GroupRecord: CustomStringConvertible {
    var description: String {
        return "«group of \(header.label)»"
    }
}

//
//struct BinaryGroupRecord: RecordProtocol {
//    static let tag = Tag("GRUP")
//    static var fieldMap = FieldTypeMap()
//
//    let _header: RecordHeader
//    let _children: Data
//
//    init(header: RecordHeader, children: Data) {
//        self._header = header
//        self._children = children
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        _header = try container.decode(RecordHeader.self)
//        _children = Data()
//    }
//
//    func binaryEncode(to encoder: BinaryEncoder) throws {
//        assert(isGroup)
//        var container = encoder.unkeyedContainer()
//        try container.encode(_header.type)
//        try container.encode(UInt32(_children.count + 24))
//        try container.encode(_header)
//        try container.encode(_children)
//    }
//}
//
//extension BinaryGroupRecord: CustomStringConvertible {
//    var description: String {
//        return "«group of \(header.label)»"
//    }
//}
