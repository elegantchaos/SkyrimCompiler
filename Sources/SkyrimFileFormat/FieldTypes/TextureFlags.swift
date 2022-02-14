//
//  File.swift
//  
//
//  Created by Sam Deane on 14/02/2022.
//

import Foundation
import CoreText


public enum TextureFlag: String, Codable, CaseIterable {
    case noSpecularMap
    case hasFacegenTextures
    case hasModelSpaceNormalMap
}

public struct TextureFlags: OptionSetFromEnum
{
    public typealias OptionType = TextureFlag

    public init(from decoder: Decoder) throws {
        self.init(rawValue: try TextureFlags.decodeRawValue(from: decoder))
    }
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }

    public let rawValue: UInt16
}
