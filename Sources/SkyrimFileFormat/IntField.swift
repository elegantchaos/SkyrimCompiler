// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

struct FieldInt<N: FixedWidthInteger>: FieldProtocol, Decodable where N: Decodable {
    let intValue: N

    static func unpack(header: Field.Header, data: Bytes, with processor: Processor) throws -> Any {
        let decoder = FieldDecoder(header: header, data: data)
        return decoder.decode(Self.self)
    }
}
