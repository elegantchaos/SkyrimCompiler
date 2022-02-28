// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

public struct BSAHeader: BinaryCodable {
    public let fileID: Tag
    public let version: UInt32
    public let offset: UInt32
    public let flags: BSAFlags
    public let folderCount: UInt32
    public let fileCount: UInt32
    public let totalFolderNameLength: UInt32
    public let totalFileNameLength: UInt32
    public let fileFlags: UInt16
    public let padding: UInt16
}
