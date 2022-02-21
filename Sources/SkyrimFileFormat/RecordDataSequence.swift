// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 21/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Foundation

protocol RecordDataIterator {
    func next() async throws -> RecordData?
}

class WrappedRecordDataIterator<I: AsyncByteSequence>: RecordDataIterator {
    internal init(iterator: AsyncThrowingIteratorMapSequence<I, RecordData>.AsyncIterator) {
        self.iterator = iterator
    }
    
    var iterator: AsyncThrowingIteratorMapSequence<I, RecordData>.AsyncIterator
    func next() async throws -> RecordData? {
        return try await iterator.next()
    }
}

