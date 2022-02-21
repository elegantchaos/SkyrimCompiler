// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol DecodableFromIntOrString: BinaryCodable, CaseIterable, RawRepresentable where RawValue == String {
    init(from decoder: Decoder) throws
}

extension DecodableFromIntOrString {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let uint = try? container.decode(UInt32.self) {
            let index = Self.allCases.index(Self.allCases.startIndex, offsetBy: Int(uint))
            self = Self.allCases[index]
        } else {
            let string = try container.decode(String.self)
            if let value = Self(rawValue: string) {
                self = value
            } else {
                throw DecodingError.valueNotFound(Self.self, .init(codingPath: decoder.codingPath, debugDescription: "Couldn't decode \(Self.self)"))
            }
        }
    }
    
    init(fromBinary decoder: BinaryDecoder) throws {
        let container = try decoder.singleValueContainer()
        let uint = try container.decode(UInt32.self)
        let index = Self.allCases.index(Self.allCases.startIndex, offsetBy: Int(uint))
        guard index < Self.allCases.endIndex else { throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Index \(index) out of range for \(Self.self)"))}
        self = Self.allCases[index]
    }
    
    func binaryEncode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let uint = UInt32(indexInCases)
        try container.encode(uint)
    }

    var indexInCases: Int {
        var n = 0
        for c in Self.allCases {
            if c == self {
                return n
            }
            n += 1
        }
        fatalError("This instance isn't in allCases")
    }
    
    func decodeFromStringOrInt(from decoder: Decoder) throws -> Self {
        let container = try decoder.singleValueContainer()
        if let uint = try? container.decode(UInt32.self) {
            let index = Self.allCases.index(Self.allCases.startIndex, offsetBy: Int(uint))
            return Self.allCases[index]
        } else {
            let string = try container.decode(String.self)
            if let value = Self(rawValue: string) {
                return value
            } else {
                throw DecodingError.valueNotFound(Self.self, .init(codingPath: decoder.codingPath, debugDescription: "Couldn't decode \(Self.self)"))
            }
        }
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
