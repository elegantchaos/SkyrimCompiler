// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SkyrimFileFormat
import XCTest

class PartNodeTests: XCTestCase {
    func testRoundtrip() throws {
        let partNode: PartNodeFlags = [.head, .addOn11, .body]
        let encoder = JSONEncoder()
        let data = try encoder.encode(partNode)
        print(String(data: data, encoding: .utf8)!)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(PartNodeFlags.self, from: data)
        XCTAssertEqual(partNode, decoded)
    }
}
