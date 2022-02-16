// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct Record {
    init(type: Tag, header: RecordHeader, data: Bytes) async throws {
        self.type = type
        self.header = header
        self.data = data
    }
    
    let type: Tag
    let header: RecordHeader
    let data: Bytes

    var name: String {
        guard let id = header.id, id != 0 else { return "[\(label)]" }
        return String(format: "[%@:%08X]", label, id)
    }
    
    var isGroup: Bool {
        type == GroupRecord.tag
    }
    
    var groupType: GroupType? {
        guard isGroup else { return nil }
        return GroupType(rawValue: header.id ?? 0)
    }

    var label: String { return header.label }
}

extension Record: CustomStringConvertible {
    var description: String {
        return "«\(name)»"
    }
}
