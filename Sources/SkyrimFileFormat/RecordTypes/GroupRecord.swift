// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct GroupRecord: RecordProtocol {
    static let tag = Tag("GRUP")
    static let fileExtension = "espg"
    
    let _header: RecordHeader
    let _children: [RecordProtocol]
    
    init(header: RecordHeader, children: [RecordProtocol]) {
        self._header = header
        self._children = children
    }

    static var fieldMap = FieldTypeMap()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(_header)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        _header = try container.decode(RecordHeader.self)
        _children = []
    }
}

extension GroupRecord: CustomStringConvertible {
    var description: String {
        return "«group of \(header.label)»"
    }
}
