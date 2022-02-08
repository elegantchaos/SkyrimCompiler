// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation


struct RealisedRecordIterator<I: AsyncByteSequence>: AsyncIteratorProtocol {
    var records: AsyncThrowingIteratorMapSequence<I, Record>.AsyncIterator
    let processor: Processor

    mutating func next() async throws -> RecordProtocol? {
        guard let record = try await records.next() else { return nil }

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
    typealias AsyncIterator = RealisedRecordIterator<I>
    typealias Element = RecordProtocol
    
    let data: I
    let processor: Processor

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(records: processor.records(bytes: data).makeAsyncIterator(), processor: processor)
    }
}
