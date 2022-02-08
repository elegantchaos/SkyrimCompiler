// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

class FieldInt<N: FixedWidthInteger>: Field {
    let intValue: N

    required init<S>(header: Field.Header, iterator: inout AsyncBufferedIterator<S>, configuration: Configuration) async throws where S : AsyncIteratorProtocol, S.Element == UInt8 {
        intValue = try await iterator.next(littleEndian: N.self)
        super.init(header: header)
    }

    override var description: String {
        "«\(header.type) \(intValue)»"
    }
    
    override var value: Any {
        return intValue
    }
}
