// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

struct RecordHeader: Codable {
    static let binaryEncodedSize = 16
    
    let type: Tag
    let flags: UInt32?
    let id: UInt32?
    let timestamp: UInt16?
    let versionControlInfo1: UInt16?
    let version: UInt16?
    let versionControlInfo2: UInt16?
    
    init(type: Tag) {
        self.type = type
        self.flags = nil
        self.id = nil
        self.timestamp = nil
        self.versionControlInfo1 = nil
        self.version = nil
        self.versionControlInfo2 = nil
    }
    
    init(type: Tag, _ stream: DataStream) async throws {
        self.type = type
        self.flags = try await stream.readNonZero(UInt32.self)
        self.id = try await stream.readNonZero(UInt32.self)
        self.timestamp = try await stream.readNonZero(UInt16.self)
        self.versionControlInfo1 = try await stream.readNonZero(UInt16.self)
        self.version = try await stream.read(UInt16.self, not: 44)
        self.versionControlInfo2 = try await stream.readNonZero(UInt16.self)
    }
}

extension RecordHeader: BinaryEncodable {
    func binaryEncode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(flags ?? 0)
        try container.encode(id ?? 0)
        try container.encode(timestamp ?? 0)
        try container.encode(versionControlInfo1 ?? 0)
        try container.encode(version ?? 44)
        try container.encode(versionControlInfo2 ?? 0)
    }
}



struct RecordHeaderFlags: OptionSetFromEnum {
    enum Options: String, EnumForOptionSet {
        case master
        case bit2
        case bit3
        case bit4
        case deletedGroup
        case deletedRecord
        case constant
        case localized
        case mustUpdateAnims
        case light
        case questItem
        case initiallyDisabled
        case ignored
        case visibleWhenDistant
        case randomAnimationStart
        case dangerous
        case compressed
        case cantWait
        case ignoreObjectInteraction
        case isMarker
        case obstacle
        case navMeshGen
    }
    
    let rawValue: UInt32
    
    init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}
