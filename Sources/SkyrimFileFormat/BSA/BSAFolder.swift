// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

public struct BSAFolder: BinaryCodable {
    let name: String?
    let nameHash: UInt64
    let offset: UInt32
    let files: [BSAFile]
    
    public init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        self.nameHash = try container.decode(UInt64.self)
        let count = try container.decode(UInt32.self)
        _ = try container.decode(UInt32.self)
        self.offset = try container.decode(UInt32.self)
        _ = try container.decode(UInt32.self)
        
        if decoder.decodeBSADirectoryNames {
            let length = try container.decode(UInt8.self)
            let chars = try container.decodeArray(of: UInt8.self, count: length)
            self.name = String(bytes: chars, encoding: decoder.stringEncoding)
        } else {
            self.name = nil
        }
        
        var files: [BSAFile] = []
        for _ in 0..<count {
            files.append(try container.decode(BSAFile.self))
        }
        
        self.files = files
    }
    
    public func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(nameHash)
        try container.encode(UInt32(files.count))
        try container.encode(UInt32(0))
        try container.encode(offset)
        try container.encode(UInt32(0))
    }
}
