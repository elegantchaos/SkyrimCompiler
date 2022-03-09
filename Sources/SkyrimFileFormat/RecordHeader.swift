// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Bytes
import Foundation

struct RecordHeader: Codable {
    static let binaryEncodedSize = 16
    
    let type: Tag
    let flags: RecordHeaderFlags?
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
        
        let flags = try await stream.readNonZero(UInt32.self)
        self.flags = flags.map { RecordHeaderFlags(rawValue: $0) }
        self.id = try await stream.readNonZero(UInt32.self)
        self.timestamp = try await stream.readNonZero(UInt16.self)
        self.versionControlInfo1 = try await stream.readNonZero(UInt16.self)
        self.version = try await stream.read(UInt16.self, not: 44)
        self.versionControlInfo2 = try await stream.readNonZero(UInt16.self)
    }
    
    var isCompressed: Bool {
        flags?.contains2(.compressed) ?? false
    }
    
    var groupLabel: String? {
        guard type == GroupRecord.tag, let groupType = GroupType(rawValue: id ?? 0) else { return nil }
        switch groupType {
            case .top:
                return Tag(flags?.rawValue ?? 0).description
                
            default:
                return String(describing: groupType)
        }
    }
    
    var label: String {
        return groupLabel ?? type.description
    }
}

extension RecordHeader: Equatable { }

extension RecordHeader: BinaryEncodable {
    func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(flags?.rawValue ?? 0)
        try container.encode(id ?? 0)
        try container.encode(timestamp ?? 0)
        try container.encode(versionControlInfo1 ?? 0)
        try container.encode(version ?? 44)
        try container.encode(versionControlInfo2 ?? 0)
    }
}



struct RecordHeaderFlags: OptionSetFromEnum {
    enum Options: String, EnumForOptionSet {
        case master                     // 00000001
        case bit2                       // 00000002
        case bit3                       // 00000004
        case bit4                       // 00000008
        case deletedGroup               // 00000010
        case deletedRecord              // 00000020
        case constant                   // 00000040
        case localized                  // 00000080
        case mustUpdateAnims            // 00000100
        case light                      // 00000200
        case questItem                  // 00000400
        case initiallyDisabled          // 00000800
        case ignored                    // 00001000
        case bit14                      // 00002000
        case bit15                      // 00004000
        case visibleWhenDistant         // 00008000
        case randomAnimationStart       // 00010000
        case dangerous                  // 00020000
        case compressed                 // 00040000
        case cantWait                   // 00080000
        case ignoreObjectInteraction    // 00100000
        case bit22                      // 00200000
        case bit23                      // 00400000
        case isMarker                   // 00800000
        case bit25                      // 01000000
        case obstacle                   // 02000000
        case navMeshGen                 // 04000000
    }
    
    let rawValue: UInt32
    
    init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}
