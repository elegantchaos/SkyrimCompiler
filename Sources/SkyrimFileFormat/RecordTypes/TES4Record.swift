// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Coercion
import Foundation

struct TES4Record: Codable, RecordProtocol {
    static var tag = Tag("TES4")
    
    let header: RecordHeader
    let info: TES4Header
    let desc: String?
    let author: String?
    let masters: [String]
    let tagifiedStringCount: UInt32
    let unknownCounter: UInt?
    let fields: [UnpackedField]?

    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }
    
    static var fieldMap: FieldMap {
        [
            "HEDR": .init("info", TES4Header.self),
            "CNAM": .string("author"),
            "SNAM": .string("desc"),
            "MAST": .init("masters", String.self),
            "DATA": .init("unusedData", UInt64.self),
            "INTV": .init("tagifiedStringCount", UInt32.self),
            "INTC": .init("unknownCounter", UInt32.self)
        ]
    }
}

extension TES4Record: CustomStringConvertible {
    var description: String {
        return "«TES4 \(info.version)»"
    }
}
