// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SkyrimFileFormat
import XCTest
import XCTestExtensions


class BSATests: XCTestCase {
    func testLoading() throws {
        let url = Bundle.module.url(forResource: "Example", withExtension: "bsa")!
        let bsa = try BSAFile(url: url)
        
        XCTAssertEqual(bsa.header.fileID, "BSA\0")
        XCTAssertEqual(bsa.header.version, 105)
        XCTAssertEqual(bsa.header.offset, 36)
        XCTAssertEqual(bsa.header.flags, 7)
        XCTAssertEqual(bsa.header.folderCount, 1)
        XCTAssertEqual(bsa.header.fileCount, 1)
        XCTAssertEqual(bsa.header.totalFolderNameLength, 29)
        XCTAssertEqual(bsa.header.totalFileNameLength, 14)
        XCTAssertEqual(bsa.header.fileFlags, 0)
        XCTAssertEqual(bsa.header.padding, 0)




    }
}
