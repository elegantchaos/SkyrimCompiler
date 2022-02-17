// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest

// With Swift 5 encoding, even an enum without associated values seems to be encoded
// using dictionaries, so you end up with something like { "flags": { "two": { } } }
// which is ugly.
//
// The workaround is to make the enum RawRepresentable using String, but it's a shame
// that it's necessary. The compiler ought to be smart enough to do the right thing :(

class EnumDecodingTests: XCTestCase {
    func testCoding() {
        let s = TestStruct(flags: .one)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(s)
        let json = String(data: data, encoding: .utf8)!
        XCTAssertEqual(json, "{\"flags\":\"one\"}")
    }
    
    func testDecoding() {
        let json = """
        {"flags": "two"}
        """
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(TestStruct.self, from: json.data(using: .utf8)!)
        print(decoded)
    }
}

private enum TestEnum: String, Codable {
    case one
    case two
}

private struct TestStruct: Codable {
    let flags: TestEnum
}


