// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

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
}
