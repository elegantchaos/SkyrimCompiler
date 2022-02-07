// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

class HEDRField: Field {
    override class var tag: Tag { "HEDR" }
    
    let version: Float32
    let number: UInt32
    let nextID: UInt32
    
    required init<S>(header: Field.Header, iterator: inout AsyncBufferedIterator<S>, configuration: Configuration) async throws where S : AsyncIteratorProtocol, S.Element == UInt8 {
        self.version = try await iterator.next(littleEndian: Float32.self)
        self.number = try await iterator.next(littleEndian: UInt32.self)
        self.nextID = try await iterator.next(littleEndian: UInt32.self)
        super.init(header: header)
    }
    
    override var value: Any {
        self
    }
}
