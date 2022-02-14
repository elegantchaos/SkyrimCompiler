// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import CoreText


public enum TextureFlag: String, Codable, CaseIterable {
    case noSpecularMap
    case hasFacegenTextures
    case hasModelSpaceNormalMap
}

public struct TextureFlags: OptionSetFromEnum
{
    public typealias Options = TextureFlag

    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }

    public let rawValue: UInt16
}
