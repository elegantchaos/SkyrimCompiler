// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

protocol RecordDataProvider {
    var data: Bytes { get }
}

struct LoadedRecordData: RecordDataProvider {
    let data: Bytes
}

extension RecordDataProvider {
    var asyncBytes: BytesAsyncSequence {
        data.asyncBytes
    }
}
struct RecordData {
    let type: Tag
    let header: RecordHeader
    let data: RecordDataProvider

    init(type: Tag, header: RecordHeader, data: RecordDataProvider) async throws {
        self.type = type
        self.header = header
        self.data = data
    }
    
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

extension RecordData: CustomStringConvertible {
    var description: String {
        return "«\(name)»"
    }
}
