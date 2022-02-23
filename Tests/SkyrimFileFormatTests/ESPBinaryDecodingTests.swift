// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import SkyrimFileFormat

final class ESPBinaryDecodingTests: ProcessorTestCase {
    func saveExample(named name: String) async throws {
        let bundle = try await unpackExample(named: name)
        try await processor.save(bundle, to: outputDirectoryURL)
        await show(outputDirectoryURL)
    }


    
    func testArmour() async throws {
        let bundle = try await unpackExample(named: "Armour")
        for record in bundle.records {
            if record is ARMORecord {
                let json = try record.asJSON(with: processor)
                print(String(data: json, encoding: .utf8)!)
            }
        }
    }

    func testPrintEmpty() async throws {
        let bundle = try await unpackExample(named: "Empty")
        for record in bundle.records {
            let json = try record.asJSON(with: processor)
            print(String(data: json, encoding: .utf8)!)
        }
    }

    func testDialogueExample() async throws {
        _ = try await unpackExample(named: "Dialogue")
    }

    func testUnpackEmpty() async throws {
        try await saveExample(named: "Empty")
    }

    func testUnpackArmour() async throws {
        try await saveExample(named: "Armour")
    }

    func testUnpackDialogue() async throws {
        try await saveExample(named: "Dialogue")
    }
}
