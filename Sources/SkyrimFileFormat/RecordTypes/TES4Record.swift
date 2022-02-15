// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct TES4Record: Codable, RecordProtocol {
    static var tag = Tag("TES4")
    
    let _header: RecordHeader
    let _fields: UnpackedFields?

    let info: TES4HeaderField
    var desc: String?
    var author: String?
    var masters: [String]
    var masterData: [UInt64]
    let tagifiedStringCount: UInt32
    let unknownCounter: UInt32?
    
    init(description: String? = nil, author: String? = nil) {
        self._header = .init(type: Self.tag)
        self._fields = nil
        self.info = .init(version: 44, number: 0, nextID: 0)
        self.desc = description
        self.author = author
        self.masters = []
        self.masterData = []
        self.tagifiedStringCount = 0
        self.unknownCounter = 0
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
