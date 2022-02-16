// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest

@testable import SkyrimFileFormat



class ESPJSONDecodingTests: ProcessorTestCase {
    func loadESPS(named name: String) async throws -> ESPS {
        let url = Bundle.module.url(forResource: "Unpacked/\(name)", withExtension: "esps")!
        return try processor.loadESPS(url)
//        let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
//
//        var loaded: [RecordProtocol] = []
//        let decoder = JSONDecoder()
//        for url in urls {
//            let data = try Data(contentsOf: url)
//            let stub = try decoder.decode(RecordStub.self, from: data)
//            let type = processor.configuration.recordClass(for: stub._header.type)
//            let decoded = try type.fromJSON(data, with: processor)
//            loaded.append(decoded)
//        }
//
//        return loaded
    }

    func testEmpty() async throws {
        let records = try await loadESPS(named: "Empty")
        XCTAssertEqual(records.count, 1)
        let header = records.header
        XCTAssertEqual(header?.tag, TES4Record.tag)
        XCTAssertEqual(header?.info.version, 1.7)
    }
}
