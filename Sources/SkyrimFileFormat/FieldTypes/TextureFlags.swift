// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct TextureFlags: OptionSetFromEnum
{
    public enum Options: String, EnumForOptionSet {
        case noSpecularMap
        case hasFacegenTextures
        case hasModelSpaceNormalMap
    }
    
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }

    public let rawValue: UInt16
}
