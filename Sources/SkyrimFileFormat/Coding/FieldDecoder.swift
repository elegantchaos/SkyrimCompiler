// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

class FieldDecoder: BinaryDecoder {
    let header: Field.Header
    let recordType: Tag
    let recordHeader: RecordHeader
    
    internal init(header: Field.Header, data: Bytes, inRecord recordType: Tag, withHeader recordHeader: RecordHeader) {
        self.header = header
        self.recordType = recordType
        self.recordHeader = recordHeader
        super.init(bytes: data)
    }
    
    var version: Int {
        Int(recordHeader.version ?? 44)
    }
}
