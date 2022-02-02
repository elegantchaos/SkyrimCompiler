// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import SkyrimFileFormat

@objc class Context: NSObject {
    let processor = Processor(configuration: Configuration())
}

final class SkyrimFileFormatTests: XCTestCase {
    func testExample() async {
        let context = Context()
        let url = Bundle.module.url(forResource: "Example/Example", withExtension: "esp")!
        await context.processor.process(url: url) { record, processor in
            do {
                try await record.test(context)
            } catch {
                print(error)
            }
        }
    }
    
}

extension Record {
    @objc func test(_ context: Context) async throws {
        print("Testing \(self)")
    }
}

extension TES4Record {
    @objc override func test(_ context: Context) async throws {
        try await super.test(context)
        
        XCTAssertEqual(header.version, 44)
        XCTAssertEqual(version, 1.7)
        XCTAssertEqual(count, 12)
        XCTAssertEqual(nextID, 0x1d8c)
        XCTAssertEqual(author, "AirChomp")
        XCTAssertEqual(desc, "Adds a black variant of the common farmer gloves, buyable at Radient Raiment and lootable from Warlocks.")
        XCTAssertEqual(masters, ["Skyrim.esm"])

    }
}
