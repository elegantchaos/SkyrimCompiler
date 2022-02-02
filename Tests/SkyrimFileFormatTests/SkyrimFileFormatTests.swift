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

        var index: [Tag:[Field]] = [:]
        for try await field in context.processor.fields(bytes: fieldData) {
            var list = index[type(of: field).tag] ?? []
            list.append(field)
            index[type(of: field).tag] = list
        }
        
        XCTAssertEqual(index[HEDRField.tag]?.count, 1)
        let header = index[HEDRField.tag]?.first as! HEDRField
        print(header)
        XCTAssertEqual(header.version, Float32(1.7))
        XCTAssertEqual(header.number, 12)
        XCTAssertEqual(header.nextID, 0x1d8c)
    }
}
