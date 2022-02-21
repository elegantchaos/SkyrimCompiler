// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest

@testable import SkyrimFileFormat



class ESPJSONDecodingTests: ProcessorTestCase {
    func loadESPS(named name: String) async throws -> ESPBundle {
        let url = Bundle.module.url(forResource: "Unpacked/\(name)", withExtension: "esps")!
        return try processor.loadESPS(url)
    }

    func testEmpty() async throws {
        let records = try await loadESPS(named: "Empty")
        XCTAssertEqual(records.count, 1)
        let header = records.header
        XCTAssertEqual(header?.type, TES4Record.tag)
        XCTAssertEqual(header?.info.version, 1.7)
    }
    
    func testArmour() async throws {
        let records = try await loadESPS(named: "Armour")
        XCTAssertEqual(records.count, 13)
        XCTAssertEqual(records.index[ARMORecord.tag]?.count, 1)
        XCTAssertEqual(records.index[ARMARecord.tag]?.count, 1)
        XCTAssertEqual(records.index[LVLIRecord.tag]?.count, 3)
        XCTAssertEqual(records.index[OTFTRecord.tag]?.count, 1)
        XCTAssertEqual(records.index[TXSTRecord.tag]?.count, 1)

        let header = records.header
        XCTAssertEqual(header?.type, TES4Record.tag)
        XCTAssertEqual(header?.info.version, 1.7)
    }
}