// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation

struct UnpackCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "upack",
        abstract: "Unpack an esp bundle into an esps bundle."
    )

    @Argument() var file: String
    @Argument() var output: String
    
    func run() throws {
        print(file)
        print(output)
    }
}


