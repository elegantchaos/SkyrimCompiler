// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Foundation
import Logger

@main struct Command: AsyncParsableCommand {
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
    
    func run() async throws {
        if version {
            print("version")
        } else {
            throw CleanExit.helpRequest(self)
        }
    }
    
    public static func main() async {
        do {
            var command = try parseAsRoot()
            if var asyncCommand = command as? AsyncParsableCommand {
                try await asyncCommand.run()
            } else {
                try command.run()
            }
            Logger.defaultManager.flush()
            exit()
        } catch {
            Logger.defaultManager.flush()
            exit(withError: error)
        }
    }
}
