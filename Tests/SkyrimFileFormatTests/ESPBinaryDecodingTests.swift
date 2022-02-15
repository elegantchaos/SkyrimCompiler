// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import SkyrimFileFormat

final class ESPBinaryDecodingTests: ProcessorTestCase {
    func unpackExample(named name: String) async throws {
        let url = Bundle.module.url(forResource: "Examples/\(name)", withExtension: "esp")!
        let output = outputURL(for: url)
        
        try await processor.pack(bytes: url.resourceBytes, to: output)
        await show(output)
    }
    

    
    func testArmour() async throws {
        let records = try await loadExample(named: "Armour")
        for record in records {
            if record is ARMORecord {
                let json = try record.asJSON(with: processor)
                print(String(data: json, encoding: .utf8)!)
            }
        }
    }

    func testPrintEmpty() async throws {
        let records = try await loadExample(named: "Empty")
        for record in records {
            let json = try record.asJSON(with: processor)
            print(String(data: json, encoding: .utf8)!)
        }
    }

    func testDialogueExample() async throws {
        _ = try await loadExample(named: "Dialogue")
    }

    func testUnpackEmpty() async throws {
        try await unpackExample(named: "Empty")
    }

    func testUnpackArmour() async throws {
        try await unpackExample(named: "Armour")
    }

    func testUnpackDialogue() async throws {
        try await unpackExample(named: "Dialogue")
    }
}
