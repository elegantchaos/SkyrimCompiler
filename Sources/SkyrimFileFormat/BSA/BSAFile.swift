// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

public struct BSAFile: BinaryCodable {
    var name: String?
    let nameHash: UInt64
    let rawSize: UInt32
    let offset: UInt32
    let isCompressed: Bool
    var size: UInt32 { rawSize & 0x3FFFFFFF }

    public init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        
        self.nameHash = try container.decode(UInt64.self)
        self.rawSize = try container.decode(UInt32.self)
        self.offset = try container.decode(UInt32.self)

        let archiveIsCompressed = decoder.isBSACompressed
        let flipCompressed = (rawSize & 40000000) != 0
        self.isCompressed = flipCompressed ? !archiveIsCompressed : archiveIsCompressed
    }
    
    public func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(nameHash)
        try container.encode(rawSize)
        try container.encode(offset)
    }
}
