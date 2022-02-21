// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 21/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

class BoxedIterator<Element, Iterator: AsyncIteratorProtocol>: AsyncIteratorProtocol where Iterator.Element == Element{
    var iterator: Iterator
    
    init(_ iterator: Iterator) {
        self.iterator = iterator
    }
    
    func next() async throws -> Element? {
        try await iterator.next()
    }
}

class BoxedSequence<Element, Sequence: AsyncSequence>: AsyncSequence where Sequence.Element == Element {
    let sequence: Sequence
    init(_ sequence: Sequence) {
        self.sequence = sequence
    }
    
    func makeAsyncIterator() -> BoxedIterator<Element, Sequence.AsyncIterator> {
        return BoxedIterator(sequence.makeAsyncIterator())
    }
    
    typealias AsyncIterator = BoxedIterator<Element, Sequence.AsyncIterator>
    typealias Element = AsyncIterator.Element
    
    
}
