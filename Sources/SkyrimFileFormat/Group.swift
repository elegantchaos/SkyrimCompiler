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
}

struct Group: RecordProtocol {
    let header: UnpackedHeader
    
    static var tag: Tag { .group }
    
    static func asJSON(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        return Data()
    }
}

struct UnknownRecord: RecordProtocol {
    let header: UnpackedHeader
    let fields: [UnpackedField]

    static var tag: Tag { "????" }
    
    static func asJSON(header: RecordHeader, fields: FieldProcessor, with processor: Processor) throws -> Data {
        return Data()
    }
}

