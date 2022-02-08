// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

class FieldDecoder: Decoder {
    let header: RecordHeader
    let fields: FieldProcessor
    
    internal init(header: RecordHeader, fields: FieldProcessor) {
        self.header = header
        self.fields = fields
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
        let decoder: FieldDecoder
        
        init(for decoder: FieldDecoder, path: [CodingKey]) {
            self.decoder = decoder
            self.codingPath = path
        }

        var allKeys: [K] {
            return []
        }
        
        func contains(_ key: K) -> Bool {
            print("Contains \(key.stringValue)")
            guard let tag = decoder.fields.tag(for: key.stringValue) else { return false }
            return decoder.fields.values[tag] != nil
        }
        
        func decodeNil(forKey key: K) throws -> Bool {
            fatalError("to do")
        }
        
//        func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
//            fatalError("to do")
//        }
//
//        func decode(_ type: String.Type, forKey key: K) throws -> String {
//            print("decode \(type) for key \(key) path \(codingPath)")
//            return "string"
//        }
//
//        func decode(_ type: Double.Type, forKey key: K) throws -> Double {
//            fatalError("to do")
//        }
//
//        func decode(_ type: Float.Type, forKey key: K) throws -> Float {
//            fatalError("to do")
//        }
//
//        func decode(_ type: Int.Type, forKey key: K) throws -> Int {
//            print("decode \(type) for key \(key) path \(codingPath)")
//            return 123
//        }
//
//        func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
//            fatalError("to do")
//        }
//
//        func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
//            fatalError("to do")
//        }
//
//        func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
//            fatalError("to do")
//        }
//
//        func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
//            fatalError("to do")
//        }
//
//        func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
//            fatalError("to do")
//        }
//
//        func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
//            fatalError("to do")
//        }
//
//        func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
//            fatalError("to do")
//        }
//
//        func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
//            fatalError("to do")
//        }
//
//        func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
//            fatalError("to do")
//        }
        
        func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
            switch key.stringValue {
                case "header":
                    print(T.self)
                    return UnpackedHeader(decoder.header) as! T
                    
                default:
                    print("decoding \(T.self) for \(key.stringValue)")
                    let tag = decoder.fields.tag(for: key.stringValue)!
                    return decoder.fields.values[tag] as! T
            }
//            return try decoder.decode(type)
//            print("decode \(type) for key \(key) path \(codingPath)")
//            decoder.codingPath.append(key)
//            let decoded = decoder.decode(type)
//            decoder.codingPath.removeLast()
//            return decoded
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

    class UnkeyedContainer: UnkeyedDecodingContainer {
        let decoder: FieldDecoder
        
        var codingPath: [CodingKey]
        
        var count: Int?
        
        var isAtEnd: Bool
        
        var currentIndex: Int

        init(for decoder: FieldDecoder) {
            self.decoder = decoder
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
        
        let decoder: FieldDecoder

        init(for decoder: FieldDecoder, path: [CodingKey]) {
            self.decoder = decoder
            self.codingPath = path
        }
    }

}
