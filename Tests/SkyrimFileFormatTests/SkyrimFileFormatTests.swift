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
    let processor = Processor(configuration: Configuration())
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
