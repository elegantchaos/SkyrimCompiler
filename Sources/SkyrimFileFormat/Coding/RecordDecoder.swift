// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

class RecordDecoder: Decoder {
    let header: RecordHeader
    let fields: DecodedFields
    
    enum Error: Swift.Error {
        case missingValue
        case wrongTypeOfValue
    }
    
    internal init(header: RecordHeader, fields: DecodedFields) {
        self.header = header
        self.fields = fields
        self.codingPath = []
        self.userInfo = [:]
    }
    
    func decode<T: Decodable>(_ kind: T.Type) throws -> T {
        return try T(from: self)
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
        let decoder: RecordDecoder
        
        init(for decoder: RecordDecoder, path: [CodingKey]) {
            self.decoder = decoder
            self.codingPath = path
        }

        var allKeys: [K] {
            return []
        }
        
        func contains(_ key: K) -> Bool {
            if key.stringValue == "_fields" { return decoder.fields.haveUnprocessedFields }
            return decoder.fields.values(forKey: key) != nil
        }
        
        func decodeNil(forKey key: K) throws -> Bool {
            if key.stringValue == "_fields" { return !decoder.fields.haveUnprocessedFields }
            return decoder.fields.values(forKey: key) == nil
        }
        
        func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
            switch key.stringValue {
                case RecordMetadata.propertyName:
                    assert(type == RecordMetadata.self)
                    
                    let fields = decoder.fields.unproccessedFields
                    let meta = RecordMetadata(header: decoder.header, fields: fields.count > 0 ? fields : nil)
                    return meta as! T

                default:
                    let fields = decoder.fields.values(forKey: key) ?? []

                    // we could have one or more fields of the same type,
                    // so they potentially form a list of values
                    let fieldValues = fields.map({ $0.value })

                    if let listValue = fieldValues as? T {
                        // if the fieldValues can be coerced into the type we were asked for
                        // then we must have been asked for a list of values - so just return
                        // the coerced field values
                        return listValue
                        
                    } else if let individualValue = (fieldValues as? [T])?.first {
                        // otherwise we assume that we were actually expecting just one
                        // value, so we use the first (and presumably only) field value
                        
                        assert(fieldValues.count == 1)
                        return individualValue
                        
                    } else if fields.count == 0 {
                        print("no fields for \(key.stringValue) type \(T.self)")
                        throw Error.missingValue
                    } else {
                        print("wrong type for \(key.stringValue) type \(T.self)")
                        throw Error.wrongTypeOfValue
                    }
            }
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
        let decoder: RecordDecoder
        
        var codingPath: [CodingKey]
        
        var count: Int?
        
        var isAtEnd: Bool
        
        var currentIndex: Int

        init(for decoder: RecordDecoder) {
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
        
        let decoder: RecordDecoder

        init(for decoder: RecordDecoder, path: [CodingKey]) {
            self.decoder = decoder
            self.codingPath = path
        }
    }

}
