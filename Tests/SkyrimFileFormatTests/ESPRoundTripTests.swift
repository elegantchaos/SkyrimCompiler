// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
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

    func roundTrip(record: RecordProtocol) async throws {
        print("Round trip test for \(record)")

        let encoder = DataEncoder()
        try processor.encode(record, using: encoder)
        let encoded = encoder.data

        let originalJSON = String(data: try record.asJSON(with: processor), encoding: .utf8)!

        let encodedStream = BytesAsyncSequence(bytes: encoded.littleEndianBytes)
        for try await decoded in processor.records(bytes: encodedStream, processChildren: false) {
            let decodedJSON = String(data: try decoded.asJSON(with: processor), encoding: .utf8)!
            XCTAssertEqual(originalJSON, decodedJSON)
            break
        }
        
        for child in record._children {
            try await roundTrip(record: child)
        }
    }
    
    func roundTripByRecordExample(named name: String) async throws {
        let records = try await loadExample(named: name)
        for record in records {
            do {
                try await roundTrip(record: record)
            } catch {
                print(error)
                throw error
            }
        }
    }

    func testRoundTripEmpty() async throws {
        try await roundTripExample(named: "Empty")
    }
    
    func testRoundTripArmour() async throws {
        try await roundTripByRecordExample(named: "Armour")
    }

}
