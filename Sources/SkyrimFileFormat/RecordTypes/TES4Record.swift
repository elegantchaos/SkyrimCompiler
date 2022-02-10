// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
//
//struct NamedCodingKey: CodingKey, RawRepresentable {
//    typealias RawValue = String
//
//    var rawValue: String { stringValue }
//
//
//    var stringValue: String
//
//    init(rawValue: String) {
//        self.stringValue = rawValue
//    }
//
//    init?(stringValue: String) {
//        self.stringValue = stringValue
//    }
//
//    var intValue: Int?
//
//    init?(intValue: Int) {
//        self.intValue = intValue
//        self.stringValue = "\(intValue)"
//    }
//
//
//}

struct TES4Record: Codable, RecordProtocol {
    static var tag = Tag("TES4")
    
    let header: RecordHeader
    let info: TES4Header
    var desc: String?
    let author: String?
    let masters: [String]
    let masterData: [UInt64]
    let tagifiedStringCount: UInt32
    let unknownCounter: UInt32?
    let fields: [UnpackedField]?

    private enum CodingKeys : String, CodingKey {
        case header, info = "HEDR", desc = "SNAM", author = "CNAM", masters = "MAST", masterData = "DATA", tagifiedStringCount = "INTV", unknownCounter = "INTC", fields
    }
    
    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }
    
    static var fieldMap = FieldTypeMap(paths: [
        CodingKeys.info: \Self.info,
        .author: \.author,
        .desc: \.desc,
        .masters: \.masters,
        .masterData: \.masterData,
        .tagifiedStringCount: \.tagifiedStringCount,
        .unknownCounter: \.unknownCounter
    ])
}

extension TES4Record: CustomStringConvertible {
    var description: String {
        print(CodingKeys.info)
        return "«TES4 \(info.version)»"
    }
}
