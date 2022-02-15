// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct Tag {
    let tag: UInt32
    
    init(_ tag: UInt32) {
        self.tag = tag
    }

    public init(_ value: String) {
        assert(value.count == 4)
        let tag = try! UInt32(littleEndianBytes: value.utf8Bytes)
        self.init(tag)
    }
}

extension Tag: Equatable, Hashable {
}

extension Tag: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension Tag: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        assert(value.count == 4)
        let tag = try! UInt32(littleEndianBytes: value.utf8Bytes)
        self.init(tag)
    }

}

extension Tag: BinaryEncodable {
    func binaryEncode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(tag)
    }
}

extension Tag: CustomStringConvertible {
    var description: String {
        if let string = String(bytes: tag.littleEndianBytes, encoding: .ascii) {
            return string
        }
        
        return "\(tag)"
    }
}
