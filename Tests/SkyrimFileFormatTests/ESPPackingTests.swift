// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import SkyrimFileFormat

final class ESPPackingTests: ProcessorTestCase {
    
    func packAndCompareExample(_ bundle: ESPBundle) async throws {
        let processor = Processor()
        let encoded = try processor.pack(bundle)
        
        let url = Bundle.module.url(forResource: "\(bundle.name)", withExtension: "esp")!
        let raw = try Data(contentsOf: url)
        
        XCTAssertEqual(encoded, raw)
    }
    
    func testEncoding() async throws {
        var record = TES4Record(description: "Empty ESP", author: "ScorpioSixNine")
        record.info = .init(version: 1.7, number: 0, nextID: 0x1D8C)
        record.tagifiedStringCount = 1

        let bundle = ESPBundle(name: "Empty", records: [record])
        try await packAndCompareExample(bundle)
    }
}
