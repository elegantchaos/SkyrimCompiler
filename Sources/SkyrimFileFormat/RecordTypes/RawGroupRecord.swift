// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import BinaryCoding
import Foundation

struct RawGroup: RecordProtocol {
    static var tag = Tag("rawG")
    
    let _meta: RecordMetadata
    let data: Bytes

    init(header: RecordHeader, data: RecordDataProvider) throws {
        self._meta = .init(header: header, originalData: data.data)
        self.data = data.data
    }

    static var fieldMap = FieldTypeMap()
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        assert(isGroup)
        
        var container = encoder.unkeyedContainer()
        try container.encode(_meta.header.type)
        try container.encode(UInt32(data.count + 24))
        try container.encode(_meta.header) // TODO: re-interpret header using group flags?
        try container.encode(data)
    }
}
