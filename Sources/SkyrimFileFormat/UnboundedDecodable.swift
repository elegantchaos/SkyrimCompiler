// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Something that, when binary-decoded, will potentially consume all remaining data
protocol UnboundedDecodable {
    static func decode(bytes: Int, from: Decoder) throws -> Self
}

extension Array: UnboundedDecodable where Element: Decodable {
    static var elementSize: Int { return MemoryLayout<Element>.size }
    static func decode(bytes: Int, from decoder: Decoder) throws -> Array<Element> {
        let count = bytes / elementSize
        var result = Self()
        result.reserveCapacity(count)
        for _ in 0..<count {
            result.append(try Element(from: decoder))
        }
        return result
    }
}
