// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

#if canImport(AppKit)
import AppKit

func show(_ url: URL) {
    NSWorkspace.shared.activateFileViewerSelecting([url])
}
#else
func show(_ url: URL) {
}
#endif

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
    
    func testUnpack() async {
        let context = Context()
        let url = Bundle.module.url(forResource: "Example/Example", withExtension: "esp")!
        let output = temporaryFile(named: url.deletingPathExtension().lastPathComponent, extension: "esps")
        let fm = FileManager.default
        
        try? fm.createDirectory(at: output, withIntermediateDirectories: true)

        var index = 0
        await context.processor.process(url: url) { record, processor in
            do {
                let data = try record.packed()
                let name = String(format: "%04d %@", index, record.header.type.description)
                let recordURL = output.appendingPathComponent(name).appendingPathExtension("json")
                try data.write(to: recordURL, options: .atomic)
                index += 1
            } catch {
                print(error)
            }
        }
        
        show(output)
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

struct PackedRecord: Codable {
    let header: PackedHeader
}

struct PackedHeader: Codable {
    let type: String
    let size: UInt32
    let flags: UInt32?
    let id: UInt32
    let timestamp: UInt16
    let versionInfo: UInt16?
    let version: UInt16?
    let unused: UInt16?
    
    init(_ record: Record.Header) {
        self.type = record.type.description
        self.size = record.size
        self.flags = record.flags == 0 ? nil : record.flags
        self.id = record.id
        self.timestamp = record.timestamp
        self.versionInfo = record.versionInfo == 0 ? nil : record.versionInfo
        self.version = record.version == 44 ? nil : record.version
        self.unused = record.unused == 0 ? nil : record.unused
    }
}

extension Record {
    func packed() throws -> Data {
        let header = PackedHeader(header)
        let packed = PackedRecord(header: header)
        return try JSONEncoder().encode(packed)
    }
}
