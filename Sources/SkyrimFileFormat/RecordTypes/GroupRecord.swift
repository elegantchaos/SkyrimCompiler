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
    
    init(header: RecordHeader) {
        self._header = header
    }

    static var fieldMap = FieldTypeMap()
}

extension GroupRecord: CustomStringConvertible {
    var description: String {
        return "«group of \(header.label)»"
    }
}
