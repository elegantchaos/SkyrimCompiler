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
    public let flags: UInt32
    public let folderCount: UInt32
    public let fileCount: UInt32
    public let totalFolderNameLength: UInt32
    public let totalFileNameLength: UInt32
    public let fileFlags: UInt16
    public let padding: UInt16
}

public struct BSAFile {
    public let url: URL
    public let header: BSAHeader
    
    public init(url: URL) throws {
        
        let data = try Data(contentsOf: url)
        let decoder = DataDecoder(data: data)
        
        self.url = url
        self.header = try decoder.decode(BSAHeader.self)
    }
    
    func extract(to url: URL) {
        
    }
}
