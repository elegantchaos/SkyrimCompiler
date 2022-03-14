// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct ZString: Codable, RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension ZString: BinaryCodable {
    init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        var bytes: [UInt8] = []
        while let byte = try? container.decode(UInt8.self), byte != 0 {
            bytes.append(byte)
        }
        
        guard let string = String(bytes: bytes, encoding: decoder.skyrimStringEncoding) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Couldn't decode string as \(decoder.skyrimStringEncoding)"))
        }

        self.rawValue = string
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        guard let bytes = rawValue.data(using: encoder.skyrimStringEncoding) else {
            throw EncodingError.invalidValue(rawValue, .init(codingPath: encoder.codingPath, debugDescription: "Couldn't encode \(rawValue) as \(encoder.skyrimStringEncoding)"))
        }
        
        try container.encode(bytes)
        try container.encode(UInt8(0))
    }
}
