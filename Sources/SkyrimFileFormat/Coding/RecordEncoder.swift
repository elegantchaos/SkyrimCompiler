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

class RecordEncoder: Encoder, WriteableRecordStream {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any]
    var binaryEncoder: DataEncoder
    var fieldMap: FieldTypeMap
    
    init(fields: FieldTypeMap) {
        self.codingPath = []
        self.userInfo = [:]
        self.binaryEncoder = DataEncoder()
        self.fieldMap = fields
    }
    
    func encode<T: Encodable>(_ value: T) throws -> Data {
        return try binaryEncoder.encode(value)
    }
    
    func writeInt<Value>(_ value: Value) where Value: FixedWidthInteger {
        binaryEncoder.writeInt(value)
    }
    
    func writeFloat<Value>(_ value: Value) throws where Value: BinaryFloatingPoint {
        try binaryEncoder.writeFloat(value)
    }
    
    func write(_ value: Bool) throws {
        try binaryEncoder.write(value)
    }
    
    func write(_ value: String) throws {
        try binaryEncoder.writeString(value)
    }
    
    func writeEncodable<Value>(_ value: Value) throws where Value: Encodable {
        try binaryEncoder.writeEncodable(value)
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(KeyedContainer(for: self, path: codingPath))
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContainer(for: self)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return SingleValueContainer(for: self, path: codingPath)
    }
    
    struct UnkeyedContainer: UnkeyedEncodingContainer, WriteableRecordStreamEncodingAdaptor {
        var codingPath: [CodingKey]
        var stream: WriteableRecordStream
        var count: Int
        
        init(for encoder: WriteableRecordStream) {
            self.stream = encoder
            self.codingPath = []
            self.count = 0
        }
    }
    
    struct SingleValueContainer: SingleValueEncodingContainer, WriteableRecordStreamEncodingAdaptor {
        var codingPath: [CodingKey]
        var stream: WriteableRecordStream
        
        init(for encoder: WriteableRecordStream, path codingPath: [CodingKey]) {
            self.stream = encoder
            self.codingPath = codingPath
        }
    }
    
    struct KeyedContainer<K>: KeyedEncodingContainerProtocol where K: CodingKey {
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
            switch key.stringValue {
                case "_header":
                    try encoder.writeEncodable(value)

                case "_fields":
                    let fields = value as! UnpackedFields
                    for (type,list) in fields {
                        for field in list {
                            if let data = field.hexData {
                                let header = Field.Header(type: Tag(type), size: UInt16(data.count))
                                try encoder.writeEncodable(header)
                                try encoder.writeEncodable(data)
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
//                        if let binaryEncodableValue = value as? BinaryEncodable {
//                            try binaryEncodableValue.binaryEncode(to: binaryEncoder)
//                        } else {
//                            try value.encode(to: binaryEncoder)
//                        }
                        try value.binaryEncode(to: binaryEncoder)
                        let encoded = binaryEncoder.data
                        
                        let header = Field.Header(type: tag, size: UInt16(encoded.count))
                        try encoder.writeEncodable(header)
                        try encoder.writeEncodable(encoded)
                    }
            }
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


protocol WriteableRecordStream {
    func writeInt<Value>(_ value: Value) where Value: FixedWidthInteger
    func writeFloat<Value>(_ value: Value) throws where Value: BinaryFloatingPoint
    func write(_ value: Bool) throws
    func write(_ value: String) throws
    func writeEncodable<Value>(_ value: Value) throws where Value: Encodable
}

protocol WriteableRecordStreamEncodingAdaptor {
    var stream: WriteableRecordStream { get }
}

extension WriteableRecordStreamEncodingAdaptor {
    mutating func encodeNil() throws {
        fatalError("to do")
    }
    
    mutating func encode(_ value: Bool) throws {
        fatalError("to do")
    }
    
    mutating func encode(_ value: String) throws {
        fatalError("to do")
    }
    
    mutating func encode(_ value: Double) throws {
        fatalError("to do")
    }
    
    mutating func encode(_ value: Float) throws {
        fatalError("to do")
    }
    
    mutating func encode(_ value: Int) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: Int8) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: Int16) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: Int32) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: Int64) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: UInt) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: UInt8) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: UInt16) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: UInt32) throws {
        stream.writeInt(value)
    }
    
    mutating func encode(_ value: UInt64) throws {
        stream.writeInt(value)
    }
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
        try stream.writeEncodable(value)
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("to do")
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("to do")
    }
    
    mutating func superEncoder() -> Encoder {
        fatalError("to do")
    }
    

}
