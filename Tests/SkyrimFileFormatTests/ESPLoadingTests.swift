// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest

@testable import SkyrimFileFormat



class ESPLoadingTests: ProcessorTestCase {
    func testEmpty() async throws {
        let records = try await loadExample(named: "Empty")
        XCTAssertEqual(records.count, 1)
        let header = records.header
        XCTAssertEqual(header?.type, TES4Record.tag)
        XCTAssertEqual(header?.info.version, 1.7)
    }
    
    func testArmour() async throws {
        let records = try await loadExample(named: "Armour")
        XCTAssertEqual(records.count, 6)
        XCTAssertEqual(records.index[ARMORecord.tag]?.count, 1)
        XCTAssertEqual(records.index[ARMARecord.tag]?.count, 1)
        XCTAssertEqual(records.index[LVLIRecord.tag]?.count, 3)
        XCTAssertEqual(records.index[OTFTRecord.tag]?.count, 1)
        XCTAssertEqual(records.index[TXSTRecord.tag]?.count, 1)

        let header = records.header
        XCTAssertEqual(header?.type, TES4Record.tag)
        XCTAssertEqual(header?.info.version, 1.7)
    }

    func testCollegeEntry() async throws {
        let records = try await loadExample(named: "CollegeEntry")
        XCTAssertEqual(records.count, 15)

        let header = records.header
        XCTAssertEqual(header?.type, TES4Record.tag)
        XCTAssertEqual(header?.info.version, 1.7)
    }

    func testDiplomaticImmunity() async throws {
        let records = try await loadExample(named: "DiplomaticImmunity")
        XCTAssertEqual(records.count, 3)

        let header = records.header
        XCTAssertEqual(header?.type, TES4Record.tag)
        XCTAssertEqual(header?.info.version, 1.7)
    }
    
    func testThugsNotAssassins() async throws {
        let records = try await loadExample(named: "ThugsNotAssassins")
        XCTAssertEqual(records.count, 12)

        let header = records.header
        XCTAssertEqual(header?.type, TES4Record.tag)
        XCTAssertEqual(header?.info.version, 1.7)
    }

}
