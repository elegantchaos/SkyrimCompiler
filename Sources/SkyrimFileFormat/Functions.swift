// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

enum ArgType {
    case actor(String = "")
    case container(String = "")
    case integer(String = "")
    case string(String = "")
    case float(String = "")
    case topic(String = "")
    case quest(String = "")
    case unknown(Int, String)
}

//struct Function: RawRepresentable, BinaryCodable {
//    let rawValue: UInt16
//
//    static let GetEventData = Self(rawValue: 4672)
//}

struct Function {
    let id: Int
    let name: String
    
    init(_ id: Int, ref: Bool = false, _ name: String, _ args: ArgType..., description: String? = nil) {
        self.id = id
        self.name = name
    }
}

