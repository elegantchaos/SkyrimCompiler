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

public enum PartNodeInt: UInt32, Codable, CaseIterable
{
    case head = 0x00000001 // - Head
    case hair = 0x00000002 // - Hair
    case body = 0x00000004 // - Body
    case hands = 0x00000008 // - Hands
    case forearms = 0x00000010 // - Forearms
    case amulet = 0x00000020 // - Amulet
    case ring = 0x00000040 // - Ring
    case feet = 0x00000080 // - Feet
    case calves = 0x00000100 // - Calves
    case shield = 0x00000200 // - Shield
    case tail = 0x00000400 // - Tail
    case longHair = 0x00000800 // - Long Hair
    case circlet = 0x00001000 // - Circlet
    case ears = 0x00002000 // - Ears
    case addOn3 = 0x00004000 // - Body AddOn 3
    case addOn4 = 0x00008000 // - Body AddOn 4
    case addOn5 = 0x00010000 // - Body AddOn 5
    case addOn6 = 0x00020000 // - Body AddOn 6
    case addOn7 = 0x00040000 // - Body AddOn 7
    case addOn8 = 0x00080000 // - Body AddOn 8
    case decapitateHead = 0x00100000 // - Decapitate Head
    case decapitate = 0x00200000 // - Decapitate
    case addOn9 = 0x00400000 // - Body AddOn 9
    case addOn10 = 0x00800000 // - Body AddOn 10
    case addOn11 = 0x01000000 // - Body AddOn 11
    case addOn12 = 0x02000000 // - Body AddOn 12
    case addOn13 = 0x04000000 // - Body AddOn 13
    case addOn14 = 0x08000000 // - Body AddOn 14
    case addOn15 = 0x10000000 // - Body AddOn 15
    case addOn16 = 0x20000000 // - Body AddOn 16
    case addOn17 = 0x40000000 // - Body AddOn 17
    case fx01 = 0x80000000 // - FX01
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
