// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

protocol OptionSetFromEnum: OptionSet, BinaryCodable where Options.AllCases.Index: FixedWidthInteger, RawValue: FixedWidthInteger, RawValue: BinaryCodable {
    associatedtype Options: EnumForOptionSet
    init(arrayLiteral elements: Options...)
    init(from decoder: Decoder) throws
    init(knownRawValue: RawValue)
    
    init(fromBinary decoder: BinaryDecoder) throws
    func encodeBinary(to encoder: BinaryEncoder) throws
}

protocol EnumForOptionSet: Codable, CaseIterable, Equatable, RawRepresentable where RawValue == String {
}

// TODO: add support for encoding/decoding as a single string when only one flag is present

extension OptionSetFromEnum {
    init(arrayLiteral elements: Options...) {
        var value: RawValue = 0
        let cases = Options.allCases
        for node in elements {
            if let index = cases.firstIndex(of: node) {
                value = value | (1 << RawValue(index))
            }
        }

        self.init(knownRawValue: value)
    }

    init(knownRawValue: RawValue) {
        self.init(rawValue: knownRawValue)!
    }
    
    init(from decoder: Decoder) throws {
        let cases = Options.allCases
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(RawValue.self) {
            self.init(knownRawValue: value)
        } else {
            var container = try decoder.unkeyedContainer()
            var value: RawValue = 0
            while let node = try? container.decode(Options.self), let index = cases.firstIndex(of: node) {
                value = value | (1 << index)
            }
            self.init(knownRawValue: value)
        }
    }

    func encode(to encoder: Encoder) throws {
        var index = RawValue(1)

        var container = encoder.unkeyedContainer()
        for flag in Options.allCases {
            if (rawValue & index) != 0 {
                try container.encode(flag)
            }
            index = index << 1
        }
    }
    
    init(fromBinary decoder: BinaryDecoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(rawValue: container.decode(RawValue.self))
    }
    
    func encodeBinary(to encoder: BinaryEncoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
