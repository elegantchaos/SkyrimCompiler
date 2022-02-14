// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

#if canImport(AppKit)
import AppKit

func show(_ url: URL) async {
    if ProcessInfo.processInfo.environment["OpenInVSCode"] == "1" {
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
    let context = Context()
    
    func loadExample(named name: String) async throws -> [RecordProtocol] {
        let url = Bundle.module.url(forResource: "Examples/\(name)", withExtension: "esp")!
        
        var records: [RecordProtocol] = []
        for try await record in context.processor.realisedRecords(bytes: url.resourceBytes, processChildren: true) {
            print(record)
            records.append(record)
        }
        
        return records
    }

    func unpackExample(named name: String) async throws {
        let context = Context()
        let url = Bundle.module.url(forResource: "Examples/\(name)", withExtension: "esp")!
        let output = outputURL(for: url)
        
        try await context.processor.pack(bytes: url.resourceBytes, to: output)
        await show(output)
    }
    
    func outputURL(for url: URL) -> URL {
        let output: URL
        if ProcessInfo.processInfo.environment["OutputToDesktop"] == "1" {
            let root = ("~/Desktop/Test Results" as NSString).expandingTildeInPath
            output = URL(fileURLWithPath: root).appendingPathComponent(url.lastPathComponent).deletingPathExtension().appendingPathExtension("esps")
        } else {
            output = temporaryFile(named: url.deletingPathExtension().lastPathComponent, extension: "esps")
        }
        
        try? FileManager.default.removeItem(at: output)
        try? FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
        return output
    }
    
    func testArmour() async throws {
        let records = try await loadExample(named: "Armour")
        for record in records {
            if record is ARMORecord {
                let json = try record.asJSON(with: context.processor)
                print(String(data: json, encoding: .utf8)!)
            }
        }
    }

    func testDialogueExample() async throws {
        _ = try await loadExample(named: "Dialogue")
    }

    func testUnpackArmour() async throws {
        try await unpackExample(named: "Armour")
    }

    func testUnpackDialogue() async throws {
        try await unpackExample(named: "Dialogue")
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
