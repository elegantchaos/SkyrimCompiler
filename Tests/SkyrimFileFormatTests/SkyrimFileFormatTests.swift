// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

#if canImport(AppKit)
import AppKit

func show(_ url: URL) async {
    let shouldShow = true
    
    if shouldShow {
    let config = NSWorkspace.OpenConfiguration()
    config.activates = true
    
    await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) -> Void in
        NSWorkspace.shared.open([url], withApplicationAt: URL(fileURLWithPath: "/Applications/Visual Studio Code.app"), configuration: config) { application, error in
            continuation.resume()
        }
    }
    }
}
#else
func show(_ url: URL) {
}
#endif

@testable import SkyrimFileFormat

@objc class Context: NSObject {
    let processor = Processor()
}

final class SkyrimFileFormatTests: XCTestCase {
    func loadExample(named name: String) async throws {
        let context = Context()
        let url = Bundle.module.url(forResource: "Examples/\(name)", withExtension: "esp")!
        
        for try await record in context.processor.realisedRecords(bytes: url.resourceBytes, processChildren: true) {
            print(record)
        }
    }

    func testExample() async throws {
        try await loadExample(named: "Example")
    }

    func testDialogueExample() async throws {
        try await loadExample(named: "Dialogue")
    }

    func testUnpack() async {
        let context = Context()
        let url = Bundle.module.url(forResource: "Examples/Example", withExtension: "esp")!
        let output = temporaryFile(named: url.deletingPathExtension().lastPathComponent, extension: "esps")
        let fm = FileManager.default
        
        do {
            try? fm.createDirectory(at: output, withIntermediateDirectories: true)
            try await context.processor.pack(bytes: url.resourceBytes, to: output)
        } catch {
            print(error)
        }

        await show(output)

    }
}
//
//extension RecordProtocol {
//    @objc func test(_ context: Context) async throws {
//        print("Testing \(self)")
//    }
//}
//
//extension TES4Record {
//    @objc override func test(_ context: Context) async throws {
//        try await super.test(context)
//        
//        XCTAssertEqual(header.version, 44)
//        XCTAssertEqual(version, 1.7)
//        XCTAssertEqual(count, 12)
//        XCTAssertEqual(nextID, 0x1d8c)
//        XCTAssertEqual(author, "AirChomp")
//        XCTAssertEqual(desc, "Adds a black variant of the common farmer gloves, buyable at Radient Raiment and lootable from Warlocks.")
//        XCTAssertEqual(masters, ["Skyrim.esm"])
//
//    }
//}
