// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct Record {
    init(header: RecordHeader, data: Bytes) async throws {
        self.header = header
        self.data = data
    }
    
    let header: RecordHeader
    let data: Bytes

    var name: String {
        header.id == 0 ? header.label : String(format: "%@-%08X", header.label, header.id)
    }
    
    var isGroup: Bool {
        header.isGroup
    }
}

extension Record: CustomStringConvertible {
    var description: String {
        return "«\(header) \(String(format: "0x%08X", header.id))»"
    }
}
