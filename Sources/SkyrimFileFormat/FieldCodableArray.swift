// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

protocol FieldCodableArray {
    func elements(encodedWith encoder: DataEncoder) throws -> [Data]
}

extension Array: FieldCodableArray where Element: Codable {
    func elements(encodedWith encoder: DataEncoder) throws -> [Data] {
        var results: [Data] = []
        for element in self {
            results.append(try encoder.encode(element))
        }
        return results
    }
}
