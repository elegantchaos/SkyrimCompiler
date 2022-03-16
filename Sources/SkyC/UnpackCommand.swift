// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Files
import Foundation
import SwiftESP

struct UnpackCommand: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "unpack",
        abstract: "Unpack an esp bundle into an esps bundle."
    )

    @Argument() var file: String
    @Argument() var output: String
    
    func run() async throws {
        let outputFolder = ThrowingManager.default.folder(output)
        let inputFile = ThrowingManager.default.file(file)

        guard inputFile.exists else {
            throw SkyCError.fileNotFound(inputFile)
        }
        
        let processor = Processor()
        let bundle = try await processor.unpack(url: inputFile.url)
        try await processor.save(bundle, to: outputFolder.url)
        print("Unpacked \(bundle.name) to \(outputFolder.name)")
    }
}


