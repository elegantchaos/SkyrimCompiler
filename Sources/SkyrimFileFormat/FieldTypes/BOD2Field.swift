// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct BOD2Field: Codable {
    let partFlags: PartNodeFlags
    let skill: Skill

    enum Skill: String, CaseIterable, Codable {
        case light
        case heavy
        case none
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let uint = try? container.decode(UInt32.self) {
                self = Self.allCases[Int(uint)]
            } else {
                let string = try container.decode(String.self)
                if let value = Self(rawValue: string) {
                    self = value
                } else {
                    throw DecodingError.valueNotFound(Skill.self, .init(codingPath: decoder.codingPath, debugDescription: "Couldn't decode Skill"))
                }
            }
        }
    }
}



