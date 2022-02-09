//
//  File.swift
//  
//
//  Created by Sam Deane on 09/02/2022.
//

import Foundation

enum GroupType: UInt32 {
    case top
    case worldChildren
    case interiorCellBlock
    case interiorCellSubBlock
    case exteriorCellBlock
    case exteriorCellSubBlock
    case cellChildren
    case topicChildren
    case cellPersistentChildren
    case cellTemporaryChildren
    
    func label(flags: UInt32) -> String {
        switch self {
            case .top:
                return Tag(flags).description
                
            default:
                return String(describing: self)
        }
    }
}
