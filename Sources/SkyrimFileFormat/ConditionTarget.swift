// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Compression

public enum ConditionTarget: UInt32, Codable, CaseIterable {
    case subject
    case target
    case reference
    case combatTarget
    case linkedReference
    case questAlias
    case packageData
    case eventData
    
    var conditionPrefix: String {
        switch self {
            case .combatTarget: return "CombatTarget"
            case .linkedReference: return "LinkedReference"
            case .questAlias: return "Alias"
            case .packageData: return "Package"
            case .eventData: return "Event"
            default: return "\(self)".capitalized
        }
    }
    
    init?(_ string: String) {
        for c in Self.allCases {
            if string == c.conditionPrefix {
                self = c
                return
            }
        }
        
        return nil
    }
}
