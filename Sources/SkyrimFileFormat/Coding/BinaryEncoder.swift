// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

class BinaryEncoder: Encoder {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any]
    var data: Data
    
    init() {
        self.codingPath = []
        self.userInfo = [:]
        self.data = Data()
    }
    
    func encode(_ value: Encodable) throws -> Data {
        try value.encode(to: self)
        return data
    }
    
    func write<Value>(_ value: Value) where Value: FixedWidthInteger {
        data.append(contentsOf: value.littleEndianBytes)
    }
    
    func write<Value>(_ value: Value) where Value: BinaryFloatingPoint {
        data.append(contentsOf: value.littleEndianBytes)
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
    
    struct UnkeyedContainer: UnkeyedEncodingContainer {
        var codingPath: [CodingKey]
        var encoder: BinaryEncoder
        var count: Int
        
        init(for encoder: BinaryEncoder) {
            self.encoder = encoder
            self.codingPath = []
            self.count = 0
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
            fatalError("to do")
        }
        
        mutating func encode(_ value: Int8) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Int16) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Int32) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Int64) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt8) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt16) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt32) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt64) throws {
            fatalError("to do")
        }
        
        mutating func encode<T>(_ value: T) throws where T : Encodable {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Bool) throws {
            fatalError("to do")
        }
        
        mutating func encodeNil() throws {
            fatalError("to do")
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
    
    struct SingleValueContainer: SingleValueEncodingContainer {
        var codingPath: [CodingKey]
        var encoder: BinaryEncoder
        
        init(for encoder: BinaryEncoder, path codingPath: [CodingKey]) {
            self.encoder = encoder
            self.codingPath = codingPath
        }
        
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
            fatalError("to do")
        }
        
        mutating func encode(_ value: Int8) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Int16) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Int32) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Int64) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt8) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt16) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt32) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: UInt64) throws {
            fatalError("to do")
        }
        
        mutating func encode<T>(_ value: T) throws where T : Encodable {
            fatalError("to do")
        }
        
        
    }
    
    struct KeyedContainer<K>: KeyedEncodingContainerProtocol where K: CodingKey {
        var codingPath: [CodingKey]
        var encoder: BinaryEncoder
        
        init(for encoder: BinaryEncoder, path codingPath: [CodingKey]) {
            self.encoder = encoder
            self.codingPath = codingPath
        }
        
        mutating func encodeNil(forKey key: K) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Bool, forKey key: K) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: String, forKey key: K) throws {
            fatalError("to do")
        }
        
        mutating func encode(_ value: Double, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: Float, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: Int, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: Int8, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: Int16, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: Int32, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: Int64, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: UInt, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: UInt8, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: UInt16, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: UInt32, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode(_ value: UInt64, forKey key: K) throws {
            encoder.write(value)
        }
        
        mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
            fatalError("to do")
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
        
        typealias Key = K
        
        
    }
}
