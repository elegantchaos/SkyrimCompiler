// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public enum PartNode: String, Codable, CaseIterable {
    case head
    case hair
    case body
    case hands
    case forearms
    case amulet
    case ring
    case feet
    case calves
    case shield
    case tail
    case longHair
    case circlet
    case ears
    case addOn3
    case addOn4
    case addOn5
    case addOn6
    case addOn7
    case addOn8
    case decapitateHead
    case decapitate
    case addOn9
    case addOn10
    case addOn11
    case addOn12
    case addOn13
    case addOn14
    case addOn15
    case addOn16
    case addOn17
    case fx01
}

public struct PartNodeFlags: OptionSet, Codable, ExpressibleByArrayLiteral
{
    public init(arrayLiteral elements: PartNode...) {
        var value: UInt32 = 0
        let cases = PartNode.allCases
        for node in elements {
            if let index = cases.firstIndex(of: node) {
                value = value | (1 << index)
            }
        }
        self.rawValue = value
    }
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public let rawValue: UInt32
    
    public init(from decoder: Decoder) throws {
        let cases = PartNode.allCases
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(UInt32.self) {
            self.rawValue = value
        } else if var container = try? decoder.unkeyedContainer() {
            var value: UInt32 = 0
            while let node = try? container.decode(PartNode.self), let index = cases.firstIndex(of: node) {
                value = value | (1 << index)
            }
            self.rawValue = value
        } else {
            self.rawValue = 0
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var nodes: [PartNode] = []
        var index = UInt32(1)
        for flag in PartNode.allCases {
            if (rawValue & index) != 0 {
                nodes.append(flag)
            }
            index = index << 1
        }

        var container = encoder.singleValueContainer()
        try container.encode(nodes)
    }
}
