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

        if encoded == original {
            print("Binary encoding for \(name) is identical.")
        } else if encoded.count == original.count {
            print("Binary encoding for \(name) differs but is the same size - we may have re-ordered some fields")
            let originalURL = outputFile(named: "\(name)-original", extension: "data")
            try original.write(to: originalURL)
            let encodedURL = outputFile(named: "\(name)-encoded", extension: "data")
            try encoded.write(to: encodedURL)

            print("Testing equality per-record:")
            try await roundTripByRecordExample(named: name)
        } else {
            print("Binary encoding for \(name) differs - something is broken")
            compareBundleRecords(bundle: decoded, expected: bundle)
        }
    }

    func compareBundleRecords(bundle: ESPBundle, expected: ESPBundle) {
        for key in bundle.index.keys {
            let originals = bundle.index[key]!
            let expecteds = expected.index[key]!
            
            if originals.count != expecteds.count {
                XCTFail("Bundle has \(originals.count) records, expecting \(expecteds.count).")
            }

            let pairs = zip(originals, expecteds)
            for (original, expected) in pairs {
                if original._meta.originalData?.count != expected._meta.originalData?.count {
                    XCTFail("\(original) ≠ \(expected)")
                }
            }
        }
    }
    
    func roundTripByRecordExample(named name: String) async throws {
        let bundle = try await unpackExample(named: name)
        for record in bundle.records {
            do {
                try await roundTripRecord(record)
            } catch {
                print(error)
                throw error
            }
        }
    }

    func roundTripRecord(_ record: RecordProtocol) async throws {
        print("Round trip test for \(record)")

        let packed = try processor.pack(record)
        let unpacked = try await processor.unpack(name: name, bytes: packed.asyncBytes).records.first!
        let repacked = try processor.pack(unpacked)
        if packed == repacked {
            print("Binary encoding for \(record) is identical.")
        } else {
            XCTAssertEqual(packed.count, repacked.count)
            print("Binary encoding for \(record) differs - we may have re-ordered some fields")
            XCTAssertTrue(record.isGroup || record.hasUnprocessedFields)
            print("Testing equality of JSON encodings")
            let originalJSON = String(data: try record.asJSON(with: processor), encoding: .utf8)!
            let decodedJSON = String(data: try unpacked.asJSON(with: processor), encoding: .utf8)!
            XCTAssertEqual(originalJSON, decodedJSON)
        }
        
        for child in record._children {
            try await roundTripRecord(child)
        }
    }
    

    func testRoundTripEmpty() async throws {
        try await roundTripExample(named: "Empty")
    }
    
    func testRoundTripArmour() async throws {
        try await roundTripExample(named: "Armour")
    }

    func testRoundTripDialogue() async throws {
        try await roundTripExample(named: "Dialogue")
    }

    func testRoundTripCollegeEntry() async throws {
        try await roundTripExample(named: "CollegeEntry")
    }

    func testRoundTripDiplomaticImmunity() async throws {
        try await roundTripExample(named: "DiplomaticImmunity")
    }

    func testRoundTripThugsNotAssassins() async throws {
        try await roundTripExample(named: "ThugsNotAssassins")
    }

}
