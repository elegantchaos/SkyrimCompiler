// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import AsyncSequenceReader
import Bytes

// https://en.uesp.net/wiki/Skyrim_Mod:Mod_File_Format

struct SkyrimFile {
    let url: URL
    
    let recordTypes: [Tag:Record.Type] = [
        .group: TES4Group.self,
        .tes4: TES4Record.self
    ]

    init(_ url: URL) {
        self.url = url
    }
    
    typealias Action = (Record) -> ()
    
    func process(action: @escaping Action) async {
        let configuration = Configuration(records: recordTypes)
        let processor = RecordProcessor(configuration: configuration)
        do {
            try await processor.process(bytes: url.resourceBytes, action: action)
        } catch {
            print(error)
        }
    }
}
