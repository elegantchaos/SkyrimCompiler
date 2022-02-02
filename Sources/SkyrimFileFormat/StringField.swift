// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

class StringField: Field {
    let value: String

    required init<S>(header: Field.Header, iterator: inout AsyncBufferedIterator<S>, configuration: Configuration) async throws where S : AsyncIteratorProtocol, S.Element == UInt8 {
        guard let bytes = try await iterator.collect(upToIncluding: 0, throwsIfOver: 512),
              let string = String(bytes: bytes, encoding: .utf8)
        else {
            throw SkyrimFileError.badString
        }

        self.value = string
        super.init(header: header)
    }

    override var description: String {
        "«\(header.type) \(value)»"
    }
}
