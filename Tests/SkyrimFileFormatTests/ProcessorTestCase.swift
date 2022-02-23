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
        let url = Bundle.module.url(forResource: "Examples/\(name)", withExtension: "esp")!
        return try await processor.unpack(url: url)
    }

    func loadExampleData(named name: String) throws -> Data {
        let url = Bundle.module.url(forResource: "Examples/\(name)", withExtension: "esp")!
        return try Data(contentsOf: url)
    }

    var outputDirectoryURL: URL {
        let output: URL
        if ProcessInfo.processInfo.environment["OutputToDesktop"] == "1" {
            let root = ("~/Desktop/Test Results" as NSString).expandingTildeInPath
            output = URL(fileURLWithPath: root)
        } else {
            output = temporaryDirectory()
        }
        
        try? FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
        return output
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
