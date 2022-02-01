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
            record.test()
        }
    }
    
}

extension Record {
    @objc func test() {
        print("Testing \(self)")
    }
}

extension TES4Record {
    @objc override func test() {
        XCTAssertEqual(header.version, 44)
//        
//        for field in fields {
//            
//        }
    }
}
