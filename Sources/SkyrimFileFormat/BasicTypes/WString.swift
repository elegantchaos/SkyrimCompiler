// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct WString: Codable, RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension WString: BinaryCodable {
    init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        let size = try container.decode(UInt16.self)
        let bytes = try container.decodeArray(of: UInt8.self, count: size)
        guard let string = String(bytes: bytes, encoding: decoder.skyrimStringEncoding) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Couldn't decode string as \(decoder.skyrimStringEncoding)"))
        }

        self.rawValue = string
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(UInt16(rawValue.count))
        guard let bytes = rawValue.data(using: encoder.skyrimStringEncoding) else {
            throw EncodingError.invalidValue(rawValue, .init(codingPath: encoder.codingPath, debugDescription: "Couldn't encode string \(rawValue) as \(encoder.skyrimStringEncoding)"))
        }

        try container.encode(bytes)
    }
}
