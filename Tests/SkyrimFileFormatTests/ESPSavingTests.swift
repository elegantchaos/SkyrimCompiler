// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import SkyrimFileFormat

final class ESPSavingTests: ProcessorTestCase {
    override class func setUp() {
        expressionTestChannel.enabled = false
    }
    
    func testSaveEmpty() async throws {
        try await saveExample(named: "Empty")
    }

    func testSaveArmour() async throws {
        try await saveExample(named: "Armour")
    }

    func testSaveDialogue() async throws {
        try await saveExample(named: "Dialogue")
    }

    func testSaveAngisCampTweaks() async throws {
        try await saveExample(named: "AngisCampTweaks")
    }

    func testSaveCollegeEntry() async throws {
        try await saveExample(named: "CollegeEntry")
    }

    func testSaveDiplomaticImmunity() async throws {
        try await saveExample(named: "DiplomaticImmunity")
    }

    func testSaveThugsNotAssassins() async throws {
        try await saveExample(named: "ThugsNotAssassins")
    }

}
