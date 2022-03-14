// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import Logger

struct Command: ParsableCommand {
    static var configuration =
        CommandConfiguration(
            abstract: "Skyrim File Compiler.",
            subcommands: [
                PackCommand.self,
                UnpackCommand.self
            ],
            defaultSubcommand: nil
    )
    
    @Flag(help: "Show the version.") var version = false

    func run() throws {
        if version {
            print("version")
        } else {
            throw CleanExit.helpRequest(self)
        }
    }
}

do {
    var command = try Command.parseAsRoot()
    try command.run()
    Logger.defaultManager.flush()
    Command.exit()
} catch {
    Logger.defaultManager.flush()
    Command.exit(withError: error)
}
