// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct TES4Record: Codable, RecordProtocol {
    static var tag = Tag("TES4")
    
    let _header: RecordHeader

    var info: TES4HeaderField
    var author: String?
    var desc: String?
    var masters: [String]
    var masterData: [UInt64]
    var tagifiedStringCount: UInt32
    var unknownCounter: UInt32?
    
    init(description: String? = nil, author: String? = nil) {
        self._header = .init(type: Self.tag)
        self.info = .init(version: 1.7, number: 0, nextID: 0)
        self.desc = description
        self.author = author
        self.masters = []
        self.masterData = []
        self.tagifiedStringCount = 0
        self.unknownCounter = nil
    }
    
    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.info, \Self.info, "HEDR"),
        (.author, \.author, "CNAM"),
        (.desc, \.desc, "SNAM"),
        (.masters, \.masters, "MAST"),
        (.masterData, \.masterData, "DATA"),
        (.tagifiedStringCount, \.tagifiedStringCount, "INTV"),
        (.unknownCounter, \.unknownCounter, "INTC")
    ])
}

extension TES4Record: CustomStringConvertible {
    var description: String {
        return "«TES4 \(info.version)»"
    }
}
