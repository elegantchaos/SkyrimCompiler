// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions
@testable import SkyrimFileFormat

class ESPRoundTripTests: ProcessorTestCase {
    func roundTripExample(named name: String) async throws {
        let records = try await loadExample(named: name)
        let encoded = try processor.save(records)
        let original = try loadExampleData(named: name)
        
        XCTAssertEqual(encoded, original)
    }

    func testRoundTripEmpty() async throws {
        try await roundTripExample(named: "Empty")
    }
    
    func testRoundTripArmour() async throws {
        try await roundTripExample(named: "Armour")
    }

}
