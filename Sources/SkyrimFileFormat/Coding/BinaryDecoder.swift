// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

protocol BinaryCodable: BinaryEncodable, BinaryDecodable {
    
}

protocol BinaryDecodable: Decodable {
    init(fromBinary: Decoder) throws
}

extension BinaryDecodable {
    init(fromBinary decoder: Decoder) throws {
        try self.init(from: decoder)
    }
}

extension String: BinaryCodable {
}

extension UInt8: BinaryCodable {}
extension UInt16: BinaryCodable {}
extension UInt32: BinaryCodable {}
extension UInt64: BinaryCodable {}
extension Int8: BinaryCodable {}
extension Int16: BinaryCodable {}
extension Int32: BinaryCodable {}
extension Int64: BinaryCodable {}

extension Optional: BinaryDecodable where Wrapped: BinaryDecodable {
}

extension Optional: BinaryEncodable where Wrapped: BinaryEncodable {
}

class BinaryDecoder: Decoder, ReadableBinaryStream {
    var data: Bytes
    var index: Bytes.Index

    internal convenience init(data: Data) {
        self.init(bytes: data.littleEndianBytes)
    }

    internal init(bytes: Bytes) {
        self.data = bytes
        self.index = bytes.startIndex
        self.codingPath = []
        self.userInfo = [:]
    }

    func decode<T: Decodable>(_ kind: T.Type) throws -> T {
        return try readDecodable(kind)
    }

    func readDecodable<T: Decodable>(_ kind: T.Type) throws -> T {
        if let unconstrained = kind as? UnboundedDecodable.Type {
            return try unconstrained.decode(bytes: remainingCount(), from: self) as! T
        }

        if let binaryDecodable = kind as? BinaryDecodable.Type {
            return try binaryDecodable.init(fromBinary: self) as! T
        } else {
            return try T(from: self)
        }
    }

    func read(_ count: Int) throws -> ArraySlice<Byte> {
        let end = index.advanced(by: count)
        guard end <= data.endIndex else { throw BasicDecoderError.outOfData }

        let slice = data[index..<end]
        index = end
        return slice
    }
    
    func read(until: Byte)  throws -> ArraySlice<Byte> {
        
        guard let end = data[index...].firstIndex(of: until) else { throw BasicDecoderError.outOfData }
        let slice = data[index..<end]
        index = end
        return slice
    }

    func readInt<T>(_ type: T.Type) throws -> T where T: FixedWidthInteger {
        let bytes = try read(MemoryLayout<T>.size)
        return try T(littleEndianBytes: bytes)
    }

    func readFloat<T>(_ type: T.Type) throws -> T where T: BinaryFloatingPoint {
        let bytes = try read(MemoryLayout<T>.size)
        return try T(littleEndianBytes: bytes)
    }
    
    func readAll() -> ArraySlice<Byte> {
        return data[index...]
    }
    
    func remainingCount() -> Int {
        data.count - index
    }
    
    var codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey : Any]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(KeyedContainer(for: self, path: codingPath))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer(for: self)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueContainer(for: self, path: codingPath)
    }
    
    class KeyedContainer<K>: KeyedDecodingContainerProtocol where K: CodingKey {
        typealias Key = K
        
        var codingPath: [CodingKey]
        let decoder: BinaryDecoder
        
        init(for decoder: BinaryDecoder, path: [CodingKey]) {
            self.decoder = decoder
            self.codingPath = path
        }

        var allKeys: [K] {
            return []
        }
        
        func contains(_ key: K) -> Bool {
            fatalError("contains \(key.compactDescription)")
        }
        
        func decodeNil(forKey key: K) throws -> Bool {
            fatalError("decodeNil \(key.compactDescription)")
        }
        
        func decode(_ type: Float.Type, forKey key: K) throws -> Float {
            let bytes = try decoder.read(MemoryLayout<Float>.size)
            let raw = try UInt32(littleEndianBytes: bytes)
            return Float(bitPattern: raw)
        }

        func decode(_ type: Int.Type, forKey key: K) throws -> Int {
            return try decoder.readInt(type)
        }

        func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
            return try decoder.readInt(type)
        }

        func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
            return try decoder.readInt(type)
        }

        func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
            return try decoder.readInt(type)
        }

        func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
            return try decoder.readInt(type)
        }

        func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
            return try decoder.readInt(type)
        }

        func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
            return try decoder.readInt(type)
        }

        func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
            return try decoder.readInt(type)
        }

        func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
            return try decoder.readInt(type)
        }

        func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
            return try decoder.readInt(type)
        }

        func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
            if let unconstrained = type as? UnboundedDecodable.Type {
                return try unconstrained.decode(bytes: decoder.remainingCount(), from: decoder) as! T
            }

            return try T(from: decoder)
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError("to do")
        }
        
        func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            fatalError("to do")
        }
        
        func superDecoder() throws -> Decoder {
            fatalError("to do")
        }
        
        func superDecoder(forKey key: K) throws -> Decoder {
            fatalError("to do")
        }
    }

    class UnkeyedContainer: UnkeyedDecodingContainer, ReadableBinaryStreamDecodingAdaptor {
        let stream: ReadableBinaryStream
        
        var codingPath: [CodingKey]
        
        var count: Int?
        
        var isAtEnd: Bool
        
        var currentIndex: Int

        init(for decoder: ReadableBinaryStream) {
            self.stream = decoder
            self.codingPath = []
            self.count = nil
            self.currentIndex = 0
            self.isAtEnd = false
        }
    }

    class SingleValueContainer: SingleValueDecodingContainer, ReadableBinaryStreamDecodingAdaptor {
        var stream: ReadableBinaryStream
        var codingPath: [CodingKey]
        
        init(for decoder: ReadableBinaryStream, path: [CodingKey]) {
            self.stream = decoder
            self.codingPath = path
        }
    }

}



extension UnkeyedDecodingContainer {
    mutating func decodeArray<T, C>(of type: T.Type, count: C) throws -> [T] where T: Decodable, C: FixedWidthInteger {
        var result: [T] = []
        result.reserveCapacity(Int(count))
        for _ in 0..<count {
            result.append(try decode(T.self))
        }
        return result
    }
}
