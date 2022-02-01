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
            let size = header.type == "GRUP" ? header.size - 24 : header.size
            let data = try await iterator.next(bytes: [UInt8].self, count: Int(size))
            return inflate(header: header, data: data)
        }
        
        for try await record in records {
            action(record)
            try await process(record.children(), action: action)
        }
    }
    
    func inflate(header: Record.Header, data: [UInt8]) -> Record {
        do {
            switch header.type {
                case "GRUP":
                    return try TES4Group(header: header, data: data)
                    
                default:
                    break
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic record.\n\n\(error)")
        }
        
        return Record(header: header)

    }
}
