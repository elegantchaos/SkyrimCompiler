// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest

@testable import SkyrimFileFormat

struct RecordStub: Codable {
    let _header: RecordHeader
}

class ESPJSONDecodingTests: ProcessorTestCase {
    func loadESPS(named name: String) async throws -> [RecordProtocol] {
        let url = Bundle.module.url(forResource: "Unpacked/\(name)", withExtension: "esps")!
        
        let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        
        let decoder = JSONDecoder()
        for url in urls {
            let data = try Data(contentsOf: url)
            let decoded = try decoder.decode(RecordStub.self, from: data)
            print(decoded._header)
            print(url)
        }
//        var records: [RecordProtocol] = []
//        for try await record in processor.realisedRecords(bytes: url.resourceBytes, processChildren: true) {
//            print(record)
//            records.append(record)
//        }
        
        return []
    }

    func testEmpty() async throws {
        let records = try await loadESPS(named: "Empty")
    }
}
