// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct PackedRecord: Encodable {
    let header: PackedHeader
    let fields: [PackedField]
    
    init(_ header: Record.Header, fields: [Field]) {
        self.header = PackedHeader(header)
        self.fields = fields.map { PackedField($0) }
    }
    
    var containsRawFields: Bool {
        return false
    }
}
