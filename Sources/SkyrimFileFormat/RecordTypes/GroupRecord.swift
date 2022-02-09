// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct GroupRecord: RecordProtocol {
    static var tag = Tag("GRUP")

    let header: UnpackedHeader
    
    init(header: UnpackedHeader) {
        self.header = header
    }
    
    static func asJSON(header: UnpackedHeader, fields: DecodedFields, with processor: Processor) throws -> Data {
        return Data()
    }
    
    static var fieldMap: FieldMap {
        return FieldMap()
    }
}

extension GroupRecord: CustomStringConvertible {
    var description: String {
        let type = GroupType(rawValue: header.id ?? 0)!
        return "«group \(type.label(flags: header.flags ?? 0))»"
    }
}
