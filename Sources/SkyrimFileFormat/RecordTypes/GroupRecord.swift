// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct GroupRecord: RecordProtocol {
    static var tag = Tag("GRUP")

    let header: RecordHeader
    
    init(header: RecordHeader) {
        self.header = header
    }
    
    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }

    static var fieldMap = FieldTypeMap()
}

extension GroupRecord: CustomStringConvertible {
    var description: String {
        let type = GroupType(rawValue: header.id ?? 0)!
        return "«group of \(type.label(flags: header.flags ?? 0))»"
    }
}
