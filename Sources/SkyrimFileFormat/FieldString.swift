// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

struct FieldString: FieldProtocol, Codable {
    let string: String
    
    static func unpack(header: Field.Header, data: Bytes, with processor: Processor) throws -> Any {
        let decoder = FieldDecoder(header: header, data: data)
        return decoder.decode(String.self)
    }
}
