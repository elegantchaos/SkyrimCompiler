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
    var records: RecordIterator
    let processor: Processor
    let processChildren: Bool

    init(_ root: RecordIterator, processor: Processor, processChildren: Bool) {
        self.records = root
        self.processor = processor
        self.processChildren = processChildren
    }

    func next() async throws -> RecordProtocol? {
        guard let record = try await records.next() else { return nil }

        do {
            let header = record.header
            if processChildren && record.isGroup {
                var children: [RecordProtocol] = []
                let r = processor.records(bytes: record.data.asyncBytes)
                let childRecordIterator = WrappedRecordIterator(iterator: r.makeAsyncIterator())
                let childIterator = RealisedRecordIterator(childRecordIterator, processor: processor, processChildren: processChildren)
                while let child = try await childIterator.next() {
                    children.append(child)
                }
                                
                return GroupRecord(header: record.header, children: children)
            }

            let fields = try await processor.decodedFields(type: record.type, header: record.header, data: record.data)
            let recordClass = processor.configuration.recordClass(for: record.type)
            let decoder = RecordDecoder(header: header, fields: fields)
            return try recordClass.init(from: decoder)
        } catch {
            print(error)
            throw error
        }
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
