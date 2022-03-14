//
//  File.swift
//  
//
//  Created by Sam Deane on 02/02/2022.
//

#if DECODING_EXPERIMENT

import AsyncSequenceReader
import Bytes
import Foundation
import AsyncSequenceReader

class StreamDecoder<Iterator: AsyncByteIterator>: Decoder {
    var stream: AsyncBufferedIterator<Iterator>
    
    internal init(stream: AsyncBufferedIterator<Iterator>) {
        self.stream = stream
        self.codingPath = []
        self.userInfo = [:]
    }
    
    func decode<T: Decodable>(_ kind: T.Type) -> T {
        do {
            return try T(from: self)
        } catch {
            fatalError("arse")
        }
    }
    
    var codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey : Any]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(KeyedContainer(for: self, property: codingPath))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer(for: self)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueContainer(for: self, property: codingPath)
    }
    
    class KeyedContainer<K>: KeyedDecodingContainerProtocol where K: CodingKey {
        typealias Key = K
        
        var codingPath: [CodingKey]
        let stream: StreamDecoder
        
        init(for stream: StreamDecoder, property: [CodingKey]) {
            self.stream = stream
            self.codingPath = property
        }

        var allKeys: [K] {
            return []
        }
        
        func contains(_ codingKey: K) -> Bool {
            fatalError("to do")
        }
        
        func decodeNil(forKey codingKey: K) throws -> Bool {
            fatalError("to do")
        }
        
        func decode(_ type: Bool.Type, forKey codingKey: K) throws -> Bool {
            fatalError("to do")
        }
        
        func decode(_ type: String.Type, forKey codingKey: K) throws -> String {
            fatalError("to do")
        }
        
        func decode(_ type: Double.Type, forKey codingKey: K) throws -> Double {
            fatalError("to do")
        }
        
        func decode(_ type: Float.Type, forKey codingKey: K) throws -> Float {
            fatalError("to do")
        }
        
        func decode(_ type: Int.Type, forKey codingKey: K) throws -> Int {
            fatalError("to do")
        }
        
        func decode(_ type: Int8.Type, forKey codingKey: K) throws -> Int8 {
            fatalError("to do")
        }
        
        func decode(_ type: Int16.Type, forKey codingKey: K) throws -> Int16 {
            fatalError("to do")
        }
        
        func decode(_ type: Int32.Type, forKey codingKey: K) throws -> Int32 {
            fatalError("to do")
        }
        
        func decode(_ type: Int64.Type, forKey codingKey: K) throws -> Int64 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt.Type, forKey codingKey: K) throws -> UInt {
            fatalError("to do")
        }
        
        func decode(_ type: UInt8.Type, forKey codingKey: K) throws -> UInt8 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt16.Type, forKey codingKey: K) throws -> UInt16 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt32.Type, forKey codingKey: K) throws -> UInt32 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt64.Type, forKey codingKey: K) throws -> UInt64 {
            fatalError("to do")
        }
        
        func decode<T>(_ type: T.Type, forKey codingKey: K) throws -> T where T : Decodable {
            fatalError("to do")
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey codingKey: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError("to do")
        }
        
        func nestedUnkeyedContainer(forKey codingKey: K) throws -> UnkeyedDecodingContainer {
            fatalError("to do")
        }
        
        func superDecoder() throws -> Decoder {
            fatalError("to do")
        }
        
        func superDecoder(forKey codingKey: K) throws -> Decoder {
            fatalError("to do")
        }
    }

    class UnkeyedContainer: UnkeyedDecodingContainer {
        let stream: StreamDecoder
        
        var codingPath: [CodingKey]
        
        var count: Int?
        
        var isAtEnd: Bool
        
        var currentIndex: Int

        init(for stream: StreamDecoder) {
            self.stream = stream
            self.codingPath = []
            self.count = nil
            self.currentIndex = 0
            self.isAtEnd = false
        }

        func decode(_ type: String.Type) throws -> String {
            fatalError("to do")
        }
        
        func decode(_ type: Double.Type) throws -> Double {
            fatalError("to do")
        }
        
        func decode(_ type: Float.Type) throws -> Float {
            fatalError("to do")
        }
        
        func decode(_ type: Int.Type) throws -> Int {
            fatalError("to do")
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            fatalError("to do")
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            fatalError("to do")
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            fatalError("to do")
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            fatalError("to do")
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            fatalError("to do")
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            fatalError("to do")
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            fatalError("to do")
        }
        
        func decodeNil() throws -> Bool {
            fatalError("to do")
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError("to do")
        }
        
        func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError("to do")
        }
        
        func superDecoder() throws -> Decoder {
            fatalError("to do")
        }
    }

    class SingleValueContainer: SingleValueDecodingContainer {
        var codingPath: [CodingKey]
        
        func decodeNil() -> Bool {
            fatalError("to do")
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            fatalError("to do")
        }
        
        func decode(_ type: String.Type) throws -> String {
            fatalError("to do")
        }
        
        func decode(_ type: Double.Type) throws -> Double {
            fatalError("to do")
        }
        
        func decode(_ type: Float.Type) throws -> Float {
            fatalError("to do")
        }
        
        func decode(_ type: Int.Type) throws -> Int {
            fatalError("to do")
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            fatalError("to do")
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            fatalError("to do")
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            fatalError("to do")
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            fatalError("to do")
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            fatalError("to do")
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            fatalError("to do")
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            fatalError("to do")
        }
        
        let stream: StreamDecoder

        init(for stream: StreamDecoder, property: [CodingKey]) {
            self.stream = stream
            self.codingPath = property
        }
    }

}

#endif
