// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

public struct BSAFlags: OptionSetFromEnum {
    public enum Options: String, EnumForOptionSet {
        case includeDirectoryNames
        case includeFileNames
        case compressed
        case retainDirectoryNames
        case retainFileNames
        case retainNameOffsets
        case bigEndian
        case retainStringsDuringStartup
        case embeddedFileNames
        case xmemCodec
    }
    
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}
