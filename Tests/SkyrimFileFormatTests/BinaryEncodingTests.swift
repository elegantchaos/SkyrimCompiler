// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
@testable import SkyrimFileFormat

class BinaryEncodingTests: XCTestCase {
    func testSimpleStruct() throws {
        let encoder = BinaryEncoder()
        let test = Test(integer: 123, double: 123.456)
        let data = try encoder.encode(test)
        XCTAssertEqual(data.count, 16)
        
        let hex = String(hexForData: data)
        print(hex)
        
        let decoder = BinaryDecoder(data: data)
        let decoded = decoder.decode(Test.self)
        XCTAssertEqual(test, decoded)
    }
}

private struct Test: Codable, Equatable {
    let integer: Int
    let double: Double
}
