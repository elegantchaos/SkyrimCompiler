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

class RecordProcessor<S> where S: AsyncSequence, S.Element == UInt8 {

    internal init(iterator: S, configuration: Configuration) {
        self.bytes = iterator
        self.configuration = configuration
    }
    
    var bytes: S
    let configuration: Configuration
    
    typealias Action = (Record) -> ()

    func process(action: @escaping Action) async throws {
        let records = bytes.iteratorMap { iterator -> Record in
            let header = try await Record.Header(&iterator)
            let provider = ASBProvider(iterator: iterator, configuration: self.configuration)
            return try await self.inflate(header: header, iterator: &iterator, provider: provider)
        }
        
        for try await record in records {
            action(record)
            let childProcessor = RecordProcessor<BytesAsyncSequence>(iterator: record.children, configuration: configuration)
            try await childProcessor.process(action: action)
        }
    }
    
    func inflate<P: ByteProvider>(header: Record.Header, iterator: inout P.Iterator, provider: P) async throws -> Record {
        print("inflating \(header.type)")
        do {
            if let kind = configuration.records[header.type] {
                return try await kind.init(header: header, iterator: &iterator, provider: provider)
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic record.\n\n\(error)")
        }
        
        return try await Record(header: header, iterator: &iterator, provider: provider)
    }

}

