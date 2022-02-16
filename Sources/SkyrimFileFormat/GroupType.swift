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
    
    func label(flags: RecordHeaderFlags?) -> String {
        switch self {
            case .top:
                return Tag(flags?.rawValue ?? 0).description
                
            default:
                return String(describing: self)
        }
    }
}
