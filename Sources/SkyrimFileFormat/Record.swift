// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

class Record: CustomStringConvertible {
    required init(header: RecordHeader, data: Bytes) async throws {
        self.header = header
        self.data = data
    }
    
    let header: RecordHeader
    let data: Bytes

    var description: String {
        return "«\(header.type) \(String(format: "0x%08X", header.id))»"
    }
    
    var childData: BytesAsyncSequence {
        return BytesAsyncSequence(bytes: [])
    }

    var name: String {
        header.type.description
    }
    
    var isGroup: Bool {
        header.isGroup
    }
}
