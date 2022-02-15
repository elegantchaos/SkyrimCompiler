// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol WriteableBinaryStream {
    func writeInt<Value>(_ value: Value) where Value: FixedWidthInteger
    func writeFloat<Value>(_ value: Value) throws where Value: BinaryFloatingPoint
    func write(_ value: Bool) throws
    func write(_ value: String) throws
    func writeEncodable<Value>(_ value: Value) throws where Value: Encodable
}

protocol WriteableBinaryStreamEncodingAdaptor {
    var stream: WriteableBinaryStream { get }
}

extension WriteableBinaryStreamEncodingAdaptor {
    mutating func encodeNil() throws {
        fatalError("to do")
    }
    
    mutating func encode(_ value: Bool) throws {
        fatalError("to do")
    }
    
    mutating func encode(_ value: String) throws {
        try stream.write(value)
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
