// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct BOD2Field: Codable {
    let partFlags: PartNodeFlags
    let skill: UInt32
    
//    struct PartNodeFlags: OptionSet, Codable
//    {
//        let rawValue: UInt32
//
//        static let head = PartNodeFlags(rawValue: 0x00000001) // - Head
//        static let hair = PartNodeFlags(rawValue: 0x00000002) // - Hair
//        static let body = PartNodeFlags(rawValue: 0x00000004) // - Body
//        static let hands = PartNodeFlags(rawValue: 0x00000008) // - Hands
//        static let forearms = PartNodeFlags(rawValue: 0x00000010) // - Forearms
//        static let amulet = PartNodeFlags(rawValue: 0x00000020) // - Amulet
//        static let ring = PartNodeFlags(rawValue: 0x00000040) // - Ring
//        static let feet = PartNodeFlags(rawValue: 0x00000080) // - Feet
//        static let calves = PartNodeFlags(rawValue: 0x00000100) // - Calves
//        static let shield = PartNodeFlags(rawValue: 0x00000200) // - Shield
//        static let tail = PartNodeFlags(rawValue: 0x00000400) // - Tail
//        static let longHair = PartNodeFlags(rawValue: 0x00000800) // - Long Hair
//        static let circlet = PartNodeFlags(rawValue: 0x00001000) // - Circlet
//        static let ears = PartNodeFlags(rawValue: 0x00002000) // - Ears
//        static let addOn3 = PartNodeFlags(rawValue: 0x00004000) // - Body AddOn 3
//        static let addOn4 = PartNodeFlags(rawValue: 0x00008000) // - Body AddOn 4
//        static let addOn5 = PartNodeFlags(rawValue: 0x00010000) // - Body AddOn 5
//        static let addOn6 = PartNodeFlags(rawValue: 0x00020000) // - Body AddOn 6
//        static let addOn7 = PartNodeFlags(rawValue: 0x00040000) // - Body AddOn 7
//        static let addOn8 = PartNodeFlags(rawValue: 0x00080000) // - Body AddOn 8
//        static let decapitateHead = PartNodeFlags(rawValue: 0x00100000) // - Decapitate Head
//        static let decapitate = PartNodeFlags(rawValue: 0x00200000) // - Decapitate
//        static let addOn9 = PartNodeFlags(rawValue: 0x00400000) // - Body AddOn 9
//        static let addOn10 = PartNodeFlags(rawValue: 0x00800000) // - Body AddOn 10
//        static let addOn11 = PartNodeFlags(rawValue: 0x01000000) // - Body AddOn 11
//        static let addOn12 = PartNodeFlags(rawValue: 0x02000000) // - Body AddOn 12
//        static let addOn13 = PartNodeFlags(rawValue: 0x04000000) // - Body AddOn 13
//        static let addOn14 = PartNodeFlags(rawValue: 0x08000000) // - Body AddOn 14
//        static let addOn15 = PartNodeFlags(rawValue: 0x10000000) // - Body AddOn 15
//        static let addOn16 = PartNodeFlags(rawValue: 0x20000000) // - Body AddOn 16
//        static let addOn17 = PartNodeFlags(rawValue: 0x40000000) // - Body AddOn 17
//        static let fx01 = PartNodeFlags(rawValue: 0x80000000) // - FX01
//    }
    
}


enum PartNodeFlags: UInt32, Codable
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

