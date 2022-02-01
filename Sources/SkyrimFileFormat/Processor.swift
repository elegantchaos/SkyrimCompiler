// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

protocol ProcessorProtocol {
    associatedtype BaseIterator: AsyncIteratorProtocol where BaseIterator.Element == Byte
    typealias Iterator = AsyncBufferedIterator<BaseIterator>
    var configuration: Configuration { get }
}

struct ProcessorShim: ProcessorProtocol {
    typealias BaseIterator = URL.AsyncBytes.AsyncIterator
    let configuration: Configuration
}

struct ProcessorShim2: ProcessorProtocol {
    typealias BaseIterator = BytesAsyncIterator
    let configuration: Configuration
}

class Processor {
    internal init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    let configuration: Configuration
    
    typealias RecordAction = (Record, Processor) async -> ()
    typealias FieldAction = (Field, Processor) async -> ()

    func process(url: URL, action: @escaping RecordAction) async {
        do {
            try await process(bytes: url.resourceBytes, action: action)
        } catch {
            print(error)
        }
    }
    
    func process<I: AsyncByteSequence>(bytes: I, action: @escaping RecordAction) async throws {
        let records = records(bytes: bytes)
        
        for try await record in records {
            await action(record, self)
            try await process(bytes: record.childData, action: action)
        }
    }
    
    func records<I: AsyncByteSequence>(bytes: I) -> AsyncThrowingIteratorMapSequence<I, Record> {
        let records = bytes.iteratorMap { iterator -> Record in
            let header = try await Record.Header(&iterator)
            return try await self.inflate(header: header, iterator: &iterator)
        }

        return records
    }

    func fields<I>(bytes: I) -> AsyncThrowingIteratorMapSequence<I, Field> where I: AsyncSequence, I.Element == Byte {
        let sequence = bytes.iteratorMap { iterator -> Field in
            let header = try await Field.Header(&iterator)
            return try await self.inflate(header: header, iterator: &iterator)
        }
        
        return sequence
    }
    
    func inflate<I: AsyncByteIterator>(header: Record.Header, iterator: inout AsyncBufferedIterator<I>) async throws -> Record {
        do {
            if let kind = configuration.records[header.type] {
                return try await kind.init(header: header, iterator: &iterator, processor: ProcessorShim(configuration: configuration))
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic record.\n\n\(error)")
        }
        
        return try await Record(header: header, iterator: &iterator, processor: ProcessorShim2(configuration: configuration))
    }

    func inflate<I>(header: Field.Header, iterator: inout AsyncBufferedIterator<I>) async throws -> Field where I.Element == Byte {
        do {
            if let kind = configuration.fields[header.type] {
                return try await kind.init(header: header, iterator: &iterator, configuration: configuration)
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic field.\n\n\(error)")
        }
        
        return try await Field(header: header, iterator: &iterator, configuration: configuration)
    }

}

