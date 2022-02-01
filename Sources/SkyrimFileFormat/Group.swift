// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
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
    
    required init<S>(header: Header, iterator: inout AsyncBufferedIterator<S>, configuration: Configuration) async throws where S.Element == Byte {
        guard let groupType = GroupType(rawValue: header.id) else { throw SkyrimFileError.badGroupType }
        self.groupType = groupType
        try await super.init(header: header, iterator: &iterator, configuration: configuration)
    }

    var recordType: Tag? {
        switch groupType {
            case .top:
                return Tag(header.flags)
                
            default:
                return nil
        }
    }
    
    override var childData: BytesAsyncSequence {
        return data.asyncBytes
    }
    
    override var fieldData: BytesAsyncSequence {
        return BytesAsyncSequence(bytes: [])
    }

    override var description: String {
        if let type = recordType {
            return "«group of \(type) records»"
        } else {
            return "«group of \(groupType)»"
        }
    }
}

extension Tag {
    static let group: Self = "GRUP"
}
