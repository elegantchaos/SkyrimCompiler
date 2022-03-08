// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import SkyrimFileFormat

final class ESPSavingTests: ProcessorTestCase {
    func testUnpackEmpty() async throws {
        try await saveExample(named: "Empty")
    }

    func testUnpackArmour() async throws {
        try await saveExample(named: "Armour")
    }

    func testUnpackDialogue() async throws {
        try await saveExample(named: "Dialogue")
    }

    func testUnpackAngisCampTweaks() async throws {
        try await saveExample(named: "AngisCampTweaks")
    }

    func testUnpackCollegeEntry() async throws {
        expressionTestChannel.enabled = true
        try await saveExample(named: "CollegeEntry")
    }

    func testUnpackDiplomaticImmunity() async throws {
        try await saveExample(named: "DiplomaticImmunity")
    }

    func testUnpackThugsNotAssassins() async throws {
        try await saveExample(named: "ThugsNotAssassins")
    }

}
