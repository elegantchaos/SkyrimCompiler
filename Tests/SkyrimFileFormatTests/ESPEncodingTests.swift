// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import SkyrimFileFormat

final class ESPEncodingTests: ProcessorTestCase {
    
    func encodeExample(named name: String, content: [RecordProtocol]) async throws {
        let processor = Processor()
        let encoded = try processor.save(content)
        
        let url = Bundle.module.url(forResource: "Examples/\(name)", withExtension: "esp")!
        let raw = try Data(contentsOf: url)
        
        let records = try await loadExample(named: name)
        for record in records {
            let json = try record.asJSON(with: processor)
            print(String(data: json, encoding: .utf8)!)
        }

        XCTAssertEqual(encoded, raw)
    }
    
    func testEncoding() async throws {
        var record = TES4Record(description: "Empty ESP", author: "ScorpioSixNine")
        record.info = .init(version: 1.7, number: 0, nextID: 0x1D8C)
        record.tagifiedStringCount = 1
        
        try await encodeExample(named: "Empty", content: [record])
    }
}
