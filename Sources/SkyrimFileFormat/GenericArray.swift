// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol CodableArray {
    var count: Int { get }
    func forEach(_ block: (Codable) throws -> ()) throws
}

extension Array: CodableArray where Element: Codable {
    func forEach(_ block: (Codable) throws -> ()) throws {
        for element in self {
            try block(element)
        }
    }
}
