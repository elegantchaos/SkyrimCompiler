// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

class TES4Group: Record {
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
    
    let groupType: GroupType
    let data: Bytes
    
    init(header: Header, data: [UInt8]) throws {
        guard let groupType = GroupType(rawValue: header.id) else { throw SkyrimFileError.badGroupType }
        self.groupType = groupType
        self.data = data
        super.init(header: header)
    }

    var recordType: Tag? {
        switch groupType {
            case .top:
                return Tag(header.flags)
                
            default:
                return nil
        }
    }
    
    override var children: BytesAsyncSequence {
        return data.asyncBytes
    }
    
    override var description: String {
        if let type = recordType {
            return "«group of \(type) records»"
        } else {
            return "«group of \(groupType)»"
        }
    }
}
