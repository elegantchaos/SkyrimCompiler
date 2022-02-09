// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
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

struct Group: RecordProtocol {
    let header: UnpackedHeader
    
    init(header: RecordHeader) {
        self.header = UnpackedHeader(header)
    }
    
    static var tag: Tag { .group }
    
    static func asJSON(header: RecordHeader, fields: DecodedFields, with processor: Processor) throws -> Data {
        return Data()
    }
    
    static var fieldMap: FieldMap {
        return FieldMap()
    }
}

extension Group: CustomStringConvertible {
    var description: String {
        let type = GroupType(rawValue: header.id ?? 0)!
        return "«group \(type.label(flags: header.flags ?? 0))»"
    }
}
