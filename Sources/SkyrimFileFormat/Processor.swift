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
    var processor: Processor { get }
}

extension ProcessorProtocol {
    var configuration: Configuration { processor.configuration }
}

struct ProcessorShim: ProcessorProtocol {
    typealias BaseIterator = URL.AsyncBytes.AsyncIterator
    let processor: Processor
}

struct ProcessorShim2: ProcessorProtocol {
    typealias BaseIterator = BytesAsyncIterator
    let processor: Processor
}

class Processor {
    internal init(configuration: Configuration) {
        self.configuration = configuration
        self.encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
    }
    
    let configuration: Configuration
    let encoder: JSONEncoder
    
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
            let header = try await RecordHeader(&iterator)
            let data = try await header.payload(&iterator) // TODO: allow the payload read to be deferred
            return try await self.inflate(header: header, data: data)
        }

        return records
    }

//    func realisedRecords<I: AsyncByteSequence>(bytes: I) -> RealisedRecordSequence<I> {
//        let records = RealisedRecordSequence(data: bytes, processor: self)
//        return records
//    }

    
    func fields<I>(bytes: inout I, types: FieldsMap) -> AsyncThrowingIteratorMapSequence<I, Field> where I: AsyncSequence, I.Element == Byte {
        let sequence = bytes.iteratorMap { iterator -> Field in
            let header = try await Field.Header(&iterator)
            let data = try await iterator.next(bytes: Bytes.self, count: Int(header.size))
            return try await self.inflate(header: header, data: data, types: types, iterator: &iterator)
        }
        
        return sequence
    }
    
    func inflate(header: RecordHeader, data: Bytes) async throws -> Record {
        do {
            let kind = header.isGroup ? Group.self : Record.self
            return try await kind.init(header: header, data: data, processor: self)
        } catch {
            print("Error unpacking \(header.type). Falling back to basic record.\n\n\(error)")
        }
        
        return try await Record(header: header, data: data, processor: self)
    }

    func inflate<I>(header: Field.Header, data: Bytes, types: FieldsMap, iterator: inout AsyncBufferedIterator<I>) async throws -> Field where I.Element == Byte {
        do {
            if let kind = types[header.type]?.field {
                let decoder = FieldDecoder(header: header, data: data)
                let unpacked = try kind.init(from: decoder)
                return Field(header: header, value: unpacked)
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic field.\n\n\(error)")
        }
        
        return Field(header: header, value: data)
    }

    func pack<I: AsyncByteSequence>(bytes: I, to url: URL) async throws {
        let records = records(bytes: bytes)
        var index = 0
        for try await record in records {
            do {
                let label = (record.header.id == 0) ? record.name : String(format: "%@-%08X", record.name, record.header.id)
                let name = String(format: "%04d %@", index, label)
                try await record.unpack(to: url.appendingPathComponent(name), processor: self)
            } catch {
                print(error)
            }
            index += 1
        }
    }
}

