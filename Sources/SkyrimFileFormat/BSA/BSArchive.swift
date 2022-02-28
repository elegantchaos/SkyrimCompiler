// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

public struct BSArchive {
    public let url: URL
    public let data: Data
    public let header: BSAHeader
    public let folders: [BSAFolder]
    
    public init(url: URL) throws {
        
        let data = try Data(contentsOf: url)
        let decoder = BSADecoder(data: data)
        let header = try decoder.decode(BSAHeader.self)
        
        decoder.header = header

        var folders: [BSAFolder] = []
        for _ in 0..<header.folderCount {
            folders.append(try decoder.decode(BSAFolder.self))
        }

        if header.flags.contains2(.includeFileNames) {
            for i in 0..<folders.count {
                for j in 0..<folders[i].files.count {
                    folders[i].files[j].name = try decoder.decode(String.self)
                }
            }
        }
        
        self.url = url
        self.header = header
        self.folders = folders
        self.data = data
    }
    
    public func extract(to url: URL) throws {
        let fm = FileManager.default
        
        for folder in folders {
            let folderPath = folder.name ?? "\(folder.nameHash)"
            var folderURL = url
            for component in folderPath.split(whereSeparator: { c in (c == "\\") || (c == "/") }) {
                folderURL = folderURL.appendingPathComponent(String(component))
            }
            try? fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
            for file in folder.files {
                let fileName = file.name ?? "\(file.nameHash)"
                let fileURL = folderURL.appendingPathComponent(fileName)
                let fileData = data[file.offset..<file.offset+file.size]
                try fileData.write(to: fileURL)
            }
        }
    }
}
