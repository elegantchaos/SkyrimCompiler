// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct RecordHeader {
    let type: Tag
    let size: UInt32
    let flags: UInt32
    let id: UInt32
    let timestamp: UInt16
    let versionInfo: UInt16
    let version: UInt16
    let unused: UInt16
    let groupType: GroupType?
    
    init(_ stream: DataStream) async throws {
        let tag = try await stream.read(UInt32.self)
        self.type = Tag(tag)
        self.size = try await stream.read(UInt32.self)
        self.flags = try await stream.read(UInt32.self)
        self.id = try await stream.read(UInt32.self)
        self.timestamp = try await stream.read(UInt16.self)
        self.versionInfo = try await stream.read(UInt16.self)
        self.version = try await stream.read(UInt16.self)
        self.unused = try await stream.read(UInt16.self)
        self.groupType = type == GroupRecord.tag ? GroupType(rawValue: id) : nil
    }
    
    var isGroup: Bool {
        groupType != nil
    }
    
    func payload(_ stream: DataStream) async throws -> Bytes {
        let size = Int(isGroup ? self.size - 24 : self.size)
        return try await stream.read(count: size)
    }
    
    var label: String {
        if let type = groupType {
            return type.label(flags: flags)
        } else {
            return type.description
        }
    }
}

extension RecordHeader: CustomStringConvertible {
    var description: String {
        return isGroup ? "group \(label)" : "record \(label)"
    }
}
