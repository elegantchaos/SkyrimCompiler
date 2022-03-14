// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import XCTest
@testable import SkyrimFileFormat

class ProcessorTestCase: XCTestCase {
    let processor = Processor()
    
    func unpackExample(named name: String) async throws -> ESPBundle {
        let url = Bundle.module.url(forResource: "\(name)", withExtension: "esp")!
        return try await processor.unpack(url: url)
    }

    func loadExample(named name: String) async throws -> ESPBundle {
        let url = Bundle.module.url(forResource: "Unpacked/\(name)", withExtension: "esps")!
        return try processor.load(url: url)
    }

    func loadExampleData(named name: String) throws -> Data {
        let url = Bundle.module.url(forResource: "\(name)", withExtension: "esp")!
        return try Data(contentsOf: url)
    }
    
    func saveExample(named name: String) async throws {
        let bundle = try await unpackExample(named: name)
        let destination = outputDirectory(appendTestName: false)
        let url = try await processor.save(bundle, to: destination)
        await show(url)
    }
}

#if canImport(AppKit)
import AppKit

extension ProcessorTestCase {
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
}
#else
extension ProcessorTestCase {
    func show(_ url: URL) {
    }
}
#endif
