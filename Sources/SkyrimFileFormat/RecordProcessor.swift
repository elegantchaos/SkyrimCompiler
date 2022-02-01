// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

typealias RecordMap = [Tag:Record.Type]

struct Configuration {
    let records: RecordMap
}

protocol ByteProvider {
    associatedtype Iterator: AsyncIteratorProtocol where Iterator.Element == Byte
    var configuration: Configuration { get }
}

struct ASBProvider<I>: ByteProvider where I: AsyncIteratorProtocol, I.Element == Byte {
    typealias Iterator = I
    let configuration: Configuration
    init(iterator: Iterator, configuration: Configuration) {
        self.configuration = configuration
    }
}

class RecordProcessor {
    internal init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    let configuration: Configuration
    
    typealias Action = (Record) async -> ()

    func process<I>(bytes: I, action: @escaping Action) async throws where I: AsyncSequence, I.Element == Byte {
        let records = bytes.iteratorMap { iterator -> Record in
            let header = try await Record.Header(&iterator)
//            let provider = ASBProvider(iterator: iterator, configuration: self.configuration)
            return try await self.inflate(header: header, iterator: &iterator)
        }
        
        for try await record in records {
            await action(record)
            try await process(bytes: record.children, action: action)
        }
    }
    
    func inflate<I>(header: Record.Header, iterator: inout AsyncBufferedIterator<I>) async throws -> Record where I.Element == Byte {
        do {
            if let kind = configuration.records[header.type] {
                return try await kind.init(header: header, iterator: &iterator, configuration: configuration)
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic record.\n\n\(error)")
        }
        
        return try await Record(header: header, iterator: &iterator, configuration: configuration)
    }

}

