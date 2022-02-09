// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

protocol RecordIterator {
    func next() async throws -> Record?
}

class WrappedRecordIterator<I: AsyncByteSequence>: RecordIterator {
    internal init(iterator: AsyncThrowingIteratorMapSequence<I, Record>.AsyncIterator) {
        self.iterator = iterator
    }
    
    var iterator: AsyncThrowingIteratorMapSequence<I, Record>.AsyncIterator
    func next() async throws -> Record? {
        return try await iterator.next()
    }
}

class RealisedRecordIterator: AsyncIteratorProtocol {
    
    var records: [RecordIterator]
    let processor: Processor
    let processChildren: Bool

    init(_ root: RecordIterator, processor: Processor, processChildren: Bool) {
        self.records = [root]
        self.processor = processor
        self.processChildren = processChildren
    }

    func nextRecord() async throws -> Record? {
        while(records.count > 0) {
            if let record = try await records.last?.next() {
                if processChildren && record.isGroup {
                    let r = processor.records(bytes: record.data.asyncBytes)
                    let childIterator = WrappedRecordIterator(iterator: r.makeAsyncIterator())
                    records.append(childIterator)
                }
                
                return record
            }
            
            records.removeLast()
        }
        
        return nil
    }
    
    func next() async throws -> RecordProtocol? {
        guard let record = try await nextRecord() else { return nil }

        let header = record.header
        let map = try processor.configuration.fields(forRecord: header.type.description)
        let fp = FieldProcessor(map)
        try await fp.process(data: record.data, processor: processor)
        let decoder = RecordDecoder(header: header, fields: fp)
        let kind = processor.configuration.records[header.type]!
        return try kind.init(from: decoder)
    }
    
    typealias Element = RecordProtocol
}


struct RealisedRecordSequence<I: AsyncByteSequence>: AsyncSequence {
    typealias AsyncIterator = RealisedRecordIterator
    typealias Element = RecordProtocol
    
    let data: I
    let processor: Processor
    let processChildren: Bool
    
    func makeAsyncIterator() -> AsyncIterator {
        let rootIterator = WrappedRecordIterator(iterator: processor.records(bytes: data).makeAsyncIterator())
        return RealisedRecordIterator(rootIterator, processor: processor, processChildren: processChildren)
    }
}
