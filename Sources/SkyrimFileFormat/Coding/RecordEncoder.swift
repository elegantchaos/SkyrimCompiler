// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Bytes
import Foundation

enum RecordEncodingError: Error {
    case unknownField
}

class RecordEncoder: DataEncoder {
    var fieldMap: FieldTypeMap
    
    init(fields: FieldTypeMap) {
        self.fieldMap = fields
        super.init()
    }
    
    override func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        if codingPath.count == 0 {
            return KeyedEncodingContainer(KeyedRecordContainer(for: self, path: codingPath))
        } else {
            return super.container(keyedBy: type)
        }
    }
    
    struct KeyedRecordContainer<K>: KeyedEncodingContainerProtocol where K: CodingKey {
        typealias Key = K

        var codingPath: [CodingKey]
        var encoder: RecordEncoder
        
        init(for encoder: RecordEncoder, path codingPath: [CodingKey]) {
            self.encoder = encoder
            self.codingPath = codingPath
        }
        
        mutating func encodeNil(forKey key: K) throws {
            fatalError("to do")
        }
        
        mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
            encoder.debugKey(value, key: key)
            encoder.pushPath(key)
            switch key.stringValue {
                case RecordMetadata.propertyName:
                    let meta = value as! RecordMetadata
                    try encoder.writeEncodable(meta.header)

                    if let fields = meta.fields {
                        for (type,list) in fields {
                            for field in list {
                                if let data = field.hexData {
                                    let header = Field.Header(type: Tag(type), size: UInt16(data.count))
                                    try encoder.writeEncodable(header)
                                    try encoder.writeEncodable(data)
                                }
                            }
                        }
                    }
                    
                default:
                    guard let tag = encoder.fieldMap.fieldTag(forKey: key) else {
                        throw RecordEncodingError.unknownField
                    }

                    let binaryEncoder = DataEncoder()

                    if let array = value as? FieldCodableArray {
                        // if the type is an array, we need to write out each of its elements
                        // separately with the same field tag
                        for encoded in try array.elements(encodedWith: binaryEncoder) {
                            let header = Field.Header(type: tag, size: UInt16(encoded.count))
                            try encoder.writeEncodable(header)
                            try encoder.writeEncodable(encoded)
                        }
                        
                        
                    } else {
                        try value.binaryEncode(to: binaryEncoder)
                        let encoded = binaryEncoder.data
                        
                        let header = Field.Header(type: tag, size: UInt16(encoded.count))
                        try encoder.writeEncodable(header)
                        try encoder.writeEncodable(encoded)
                    }
            }
            encoder.popPath()
        }
        
        mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError("to do")
        }
        
        mutating func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
            fatalError("to do")
        }
        
        mutating func superEncoder() -> Encoder {
            fatalError("to do")
        }
        
        mutating func superEncoder(forKey key: K) -> Encoder {
            fatalError("to do")
        }
        
        
        
    }
}

