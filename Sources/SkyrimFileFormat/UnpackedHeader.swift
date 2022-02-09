// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct UnpackedHeader: Codable {
    let type: String
    let flags: UInt32?
    let id: UInt32?
    let timestamp: UInt16?
    let versionInfo: UInt16?
    let version: UInt16?
    let unused: UInt16?
    
    
    init(type: Tag, _ stream: DataStream) async throws {
        self.type = type.description
        self.flags = try await stream.read(UInt32.self)
        self.id = try await stream.read(UInt32.self)
        self.timestamp = try await stream.read(UInt16.self)
        self.versionInfo = try await stream.read(UInt16.self)
        self.version = try await stream.read(UInt16.self)
        self.unused = try await stream.read(UInt16.self)
    }
    
    init(_ record: RecordHeader) {
        self.type = record.type.description
        self.flags = record.flags == 0 ? nil : record.flags
        self.id = record.id == 0 ? nil : record.id
        self.timestamp = record.timestamp == 0 ? nil : record.timestamp
        self.versionInfo = record.versionInfo == 0 ? nil : record.versionInfo
        self.version = record.version == 44 ? nil : record.version
        self.unused = record.unused == 0 ? nil : record.unused
    }
    
}
