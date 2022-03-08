// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public enum ComparisonOperator: String, CaseIterable {
    case equals
    case notEquals
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual
    
    var keyword: String {
        switch self {
            case .equals:
                return "=="
            case .notEquals:
                return "!="
            case .greaterThan:
                return ">"
            case .greaterThanOrEqual:
                return ">="
            case .lessThan:
                return "<"
            case .lessThanOrEqual:
                return "<="
        }
    }
    
    init(flags: UInt8) {
        self = Self.allCases[Int(flags >> 5)]
    }
    
    init?(keyword: String) {
        for c in Self.allCases {
            if c.keyword == keyword {
                self = c
                return
            }
        }
        
        return nil
    }
}
