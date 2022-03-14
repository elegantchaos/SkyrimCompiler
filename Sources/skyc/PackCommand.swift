// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation

struct PackCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "pack",
        abstract: "Pack an esps bundle into an esp file."
    )

    @Argument() var bundle: String
    @Argument() var output: String
    
    func run() throws {
        print(bundle)
        print(output)
    }
}

