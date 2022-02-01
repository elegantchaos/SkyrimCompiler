// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import SkyrimFileFormat

final class SkyrimFileFormatTests: XCTestCase {
    func testExample() async {
        let url = Bundle.module.url(forResource: "Example/Example", withExtension: "esp")!
        let file = SkyrimFile(url)
        await file.process { record in
            do {
                try await record.test()
            } catch {
                print(error)
            }
        }
    }
    
}

extension Record {
    @objc func test() async throws {
        print("Testing \(self)")
    }
}

extension TES4Record {
    @objc override func test() async throws {
        try await super.test()
        
        XCTAssertEqual(header.version, 44)

        for try await field in fields {
            print(field)
//            action(record)
//            try await process(bytes: record.children, action: action)
        }
    }
}
