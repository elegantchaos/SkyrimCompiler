// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol OptionSetFromEnum: OptionSet, Codable where OptionType.AllCases.Index: FixedWidthInteger {
    associatedtype OptionType: CaseIterable, Codable, Equatable
    init(arrayLiteral elements: OptionType...)
    init(from decoder: Decoder) throws
    init(rawValue: RawValue)
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

        self.init(rawValue: value)
    }
    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let value = try? container.decode(RawValue.self) {
//            self.init(rawValue: value)
//        } else {
////            var container = try decoder.unkeyedContainer()
//            let cases = try container.decode([OptionType.self])
//
////            {
////            let cases = OptionType.allCases
////            var value: RawValue = 0
////            var index: RawValue = 1
////            for case in cases {
////
////            }
////                value = value | (1 << index)
////            }
////            self.init(rawValue: value)
////        } else {
////            self.init(rawValue: 0)
//        }
//    }

    public static func decodeRawValue(from decoder: Decoder) throws -> RawValue {
        let cases = OptionType.allCases
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(RawValue.self) {
            return value
        } else if var container = try? decoder.unkeyedContainer() {
            var value: RawValue = 0
            while let node = try? container.decode(OptionType.self), let index = cases.firstIndex(of: node) {
                value = value | (1 << index)
            }
            return value
        } else {
            return 0
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
