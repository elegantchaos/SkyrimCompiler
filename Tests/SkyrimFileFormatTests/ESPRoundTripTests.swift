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
        let bundle = try await unpackExample(named: name)
        let encoded = try processor.pack(bundle)
        let original = try loadExampleData(named: name)
        
        let decoded = try await processor.unpack(name: "Test", bytes: encoded.asyncBytes)
        XCTAssertEqual(bundle.count, decoded.count)

        XCTAssertEqual(encoded.count, original.count)
        XCTAssertEqual(encoded, original)
        
        let originalURL = outputFile(named: "\(name)-original", extension: "data")
        print(originalURL)
        try original.write(to: originalURL)
        let encodedURL = outputFile(named: "\(name)-encoded", extension: "data")
        try encoded.write(to: encodedURL)
    }

    func roundTrip(record: RecordProtocol) async throws {
        print("Round trip test for \(record)")

        let packed = try processor.pack(record)
        let unpacked = try await processor.unpack(name: name, bytes: packed.asyncBytes).records.first!
        let repacked = try processor.pack(unpacked)
        XCTAssertEqual(packed, repacked)
        
        let originalJSON = String(data: try record.asJSON(with: processor), encoding: .utf8)!
        let decodedJSON = String(data: try unpacked.asJSON(with: processor), encoding: .utf8)!
        XCTAssertEqual(originalJSON, decodedJSON)
        
        for child in record._children {
            try await roundTrip(record: child)
        }
    }
    
    func roundTripByRecordExample(named name: String) async throws {
        let bundle = try await unpackExample(named: name)
        for record in bundle.records {
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
        try await roundTripExample(named: "Armour")
    }

}
