// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

public struct TES4Record: Codable, RecordProtocol {
    public static var tag = Tag("TES4")
    
    public let _meta: RecordMetadata

    var info: TES4HeaderField
    var author: String?
    var desc: String?
    var masters: [String]
    var masterData: [UInt64]
    var tagifiedStringCount: UInt32
    var unknownCounter: UInt32?
    
    init(description: String? = nil, author: String? = nil) {
        self._meta = .init(type: Self.tag)
        self.info = .init(version: 1.7, number: 0, nextID: 0)
        self.desc = description
        self.author = author
        self.masters = []
        self.masterData = []
        self.tagifiedStringCount = 0
        self.unknownCounter = nil
    }
    
    public static var fieldMap = FieldTypeMap(fields: [
        .init(CodingKeys.info, \Self.info, "HEDR"),
        .init(.author, \.author, "CNAM"),
        .init(.desc, \.desc, "SNAM"),
        .init(.masters, \.masters, "MAST"),
        .init(.masterData, \.masterData, "DATA", groupWith: "MAST"),
        .init(.tagifiedStringCount, \.tagifiedStringCount, "INTV"),
        .init(.unknownCounter, \.unknownCounter, "INTC")
    ])
    
    public var summary: String {
        var items: [String] = []
        if let description = desc {
            items.append(description)
        }
        if let author = author {
            items.append("Author: \(author)")
        }
        
        return items.joined(separator: "\n")
    }
}

extension TES4Record: CustomStringConvertible {
    public var description: String {
        return "«TES4 \(info.version)»"
    }
}
