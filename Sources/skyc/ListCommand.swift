// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ArgumentParser
import Files
import Foundation
import SkyrimFileFormat

struct ListCommand: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List the records in an esp file."
    )

    @Argument() var file: String
    
    func run() async throws {
        let inputFile = ThrowingManager.default.file(file)

        guard inputFile.exists else {
            throw SkyCError.fileNotFound(inputFile)
        }
        
        let processor = Processor()
        let bundle = try await processor.unpack(url: inputFile.url)
        
        print(inputFile.name.fullName)
        if let header = bundle.header {
            print(header.summary)
        }
        print("")
        for record in bundle.records {
            list(record, indent: "")
        }
    }
    
    func list(_ record: RecordProtocol, indent: String) {
        if !(record is TES4Record) {
            print("\(indent)\(record.fullName)")
        }
        
        for child in record.children {
            list(child, indent: indent + "  ")
        }
    }
}


