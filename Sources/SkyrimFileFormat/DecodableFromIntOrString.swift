// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol DecodableFromIntOrString: Codable, CaseIterable, RawRepresentable where RawValue == String {
    init(from decoder: Decoder) throws
}

extension DecodableFromIntOrString {
    init(from decoder: Decoder) throws {
        self = try decodeFromStringOrInt(from: decoder)
    }
}

func decodeFromStringOrInt<T>(from decoder: Decoder) throws -> T where T: CaseIterable, T: RawRepresentable, T.RawValue == String {
    let container = try decoder.singleValueContainer()
    if let uint = try? container.decode(UInt32.self) {
        let index = T.allCases.index(T.allCases.startIndex, offsetBy: Int(uint))
        return T.allCases[index]
    } else {
        let string = try container.decode(String.self)
        if let value = T(rawValue: string) {
            return value
        } else {
            throw DecodingError.valueNotFound(T.self, .init(codingPath: decoder.codingPath, debugDescription: "Couldn't decode \(T.self)"))
        }
    }
}
