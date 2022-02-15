// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

protocol BinaryEncodable: Encodable {
    func binaryEncode(to encoder: Encoder) throws
}

extension BinaryEncodable {
    func binaryEncode(to encoder: Encoder) throws {
        try encode(to: encoder)
    }
}

enum BinaryEncodingError: Error {
    case couldntEncodeString
}

class BinaryEncoder: Encoder, WriteableBinaryStream {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any]
    var data: Data
    var stringEncoding: String.Encoding

    init() {
        self.codingPath = []
        self.userInfo = [:]
        self.data = Data()
        self.stringEncoding = .utf8
    }
    
    func encode<T: Encodable>(_ value: T) throws -> Data {
        data.removeAll()
        try writeEncodable(value)
        return data
    }
    
    func writeInt<Value>(_ value: Value) where Value: FixedWidthInteger {
        data.append(contentsOf: value.littleEndianBytes)
    }
    
    func writeFloat<Value>(_ value: Value) throws where Value: BinaryFloatingPoint {
        data.append(contentsOf: value.littleEndianBytes)
    }
    
    func write(_ value: Bool) throws {
        self.writeInt(UInt8(value ? 1 : 0))
    }
    
    func write(_ value: String) throws {
        guard let encodedString = value.data(using: stringEncoding) else {
            throw BinaryEncodingError.couldntEncodeString
        }

        data.append(encodedString)
        data.append(UInt8(0))
    }
    
    func writeEncodable<Value>(_ value: Value) throws where Value: Encodable {
        if let binary = value as? BinaryEncodable {
            try binary.binaryEncode(to: self)
        } else {
            try value.encode(to: self)
        }
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
    
    struct UnkeyedContainer: UnkeyedEncodingContainer, WriteableBinaryStreamEncodingAdaptor {
        var codingPath: [CodingKey]
        var stream: WriteableBinaryStream
        var count: Int
        
        init(for encoder: WriteableBinaryStream) {
            self.stream = encoder
            self.codingPath = []
            self.count = 0
        }
    }
    
    struct SingleValueContainer: SingleValueEncodingContainer, WriteableBinaryStreamEncodingAdaptor {
        var codingPath: [CodingKey]
        var stream: WriteableBinaryStream
        
        init(for encoder: WriteableBinaryStream, path codingPath: [CodingKey]) {
            self.stream = encoder
            self.codingPath = codingPath
        }
    }
    
    struct KeyedContainer<K>: KeyedEncodingContainerProtocol where K: CodingKey {
        typealias Key = K

        var codingPath: [CodingKey]
        var stream: WriteableBinaryStream
        
        init(for stream: WriteableBinaryStream, path codingPath: [CodingKey]) {
            self.stream = stream
            self.codingPath = codingPath
        }
        
        mutating func encodeNil(forKey key: K) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Bool, forKey key: K) throws {
            try stream.write(value)
        }
        
        mutating func encode(_ value: String, forKey key: K) throws {
            try stream.write(value)
        }
        
        mutating func encode(_ value: Double, forKey key: K) throws {
            try stream.writeFloat(value)
        }
        
        mutating func encode(_ value: Float, forKey key: K) throws {
            try stream.writeFloat(value)
        }
        
        mutating func encode(_ value: Int, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: Int8, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: Int16, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: Int32, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: Int64, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: UInt, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: UInt8, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: UInt16, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: UInt32, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode(_ value: UInt64, forKey key: K) throws {
            stream.writeInt(value)
        }
        
        mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
            try stream.writeEncodable(value)
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
