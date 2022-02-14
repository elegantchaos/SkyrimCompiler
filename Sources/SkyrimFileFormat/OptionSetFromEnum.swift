// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol OptionSetFromEnum: OptionSet, Codable where OptionType.AllCases.Index: FixedWidthInteger {
    associatedtype OptionType: CaseIterable, Codable, Equatable
    init(arrayLiteral elements: OptionType...)
    init(from decoder: Decoder) throws
    init(knownRawValue: RawValue)
}

extension OptionSetFromEnum where RawValue: FixedWidthInteger, RawValue: Decodable {
    public init(arrayLiteral elements: OptionType...) {
        var value: RawValue = 0
        let cases = OptionType.allCases
        for node in elements {
            if let index = cases.firstIndex(of: node) {
                value = value | (1 << RawValue(index))
            }
        }

        self.init(knownRawValue: value)
    }

    public init(knownRawValue: RawValue) {
        self.init(rawValue: knownRawValue)!
    }
    
    public init(from decoder: Decoder) throws {
        let cases = OptionType.allCases
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(RawValue.self) {
            self.init(knownRawValue: value)
        } else {
            var container = try decoder.unkeyedContainer()
            var value: RawValue = 0
            while let node = try? container.decode(OptionType.self), let index = cases.firstIndex(of: node) {
                value = value | (1 << index)
            }
            self.init(knownRawValue: value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var values: [OptionType] = []
        var index = RawValue(1)
        for flag in OptionType.allCases {
            if (rawValue & index) != 0 {
                values.append(flag)
            }
            index = index << 1
        }

        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}
