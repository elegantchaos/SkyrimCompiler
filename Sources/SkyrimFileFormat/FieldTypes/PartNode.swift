// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct PartNodeFlags: OptionSetFromEnum
{
    public enum Options: String, EnumForOptionSet {
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
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public let rawValue: UInt32
}
