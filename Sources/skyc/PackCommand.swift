// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Files
import Foundation
import SkyrimFileFormat

struct PackCommand: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "pack",
        abstract: "Pack an esps bundle into an esp file."
    )

    @Argument() var bundle: String
    @Argument() var output: String
    
    mutating func run() async throws {
        let outputFile = ThrowingManager.default.file(output, pathExtension: "esp")
        let bundleFolder = ThrowingManager.default.folder(bundle)
        guard bundleFolder.exists else {
            throw SkyCError.bundleNotFound(bundleFolder)
        }
        
        let processor = Processor()
        let bundle = try processor.load(url: bundleFolder.url)
        let data = try processor.pack(bundle)
        outputFile.write(asData: data)
        print("Packed \(bundle.name) to \(outputFile.name)")
    }
}

extension ThrowingManager {
    func file(_ path: String, pathExtension: String? = nil) -> ThrowingFile {
        if path.first == "/" {
            return file(for: URL(fileURLWithPath: path))
        } else {
            var url = manager.workingDirectory().appendingPathComponent(path)
            if let ext = pathExtension, url.pathExtension != ext {
                url.appendPathExtension(ext)
            }

            return file(for: url)
        }
    }

    func folder(_ path: String) -> ThrowingFolder {
        if path.first == "/" {
            return folder(for: URL(fileURLWithPath: path))
        } else {
            let url = manager.workingDirectory().appendingPathComponent(path)
            return folder(for: url)
        }
    }
}

