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
        let sequence = url.resourceBytes
        do {
            try await process(sequence, action: action)
        } catch {
            print(error)
        }
    }
    
    func process<S>(_ bytes: S, action: @escaping Action) async throws where S: AsyncSequence, S.Element == UInt8 {
        let records = bytes.iteratorMap { iterator -> Record in
            let header = try await Record.Header(&iterator)
            return try await inflate(header: header, iterator: &iterator)
        }
        
        for try await record in records {
            action(record)
            try await process(record.children, action: action)
        }
    }
    
    func inflate<S>(header: Record.Header, iterator: inout AsyncBufferedIterator<S>) async throws -> Record where S.Element == UInt8 {
        do {
            if let kind = recordTypes[header.type] {
                return try await kind.init(header: header, iterator: &iterator)
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic record.\n\n\(error)")
        }
        
        return try await Record(header: header, iterator: &iterator)

    }
}
