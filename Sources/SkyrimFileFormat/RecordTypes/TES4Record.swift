// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Coercion
import Foundation

struct TES4Record: Codable, RecordProtocol {
    static var tag = Tag("TES4")
    
    let header: RecordHeader
    let info: TES4Header
    var desc: String?
    let author: String?
    let masters: [String]
    let masterData: [UInt64]
    let tagifiedStringCount: UInt32
    let unknownCounter: UInt32?
    let fields: [UnpackedField]?

    private enum CodingKeys : String, CodingKey {
        case header, info = "HEDR", desc = "SNAM", author = "CNAM", masters = "MAST", masterData = "DATA", tagifiedStringCount = "INTV", unknownCounter = "INTC", fields
    }
    
    func asJSON(with processor: Processor) throws -> Data {
        return try processor.encoder.encode(self)
    }
    
    struct Wibble<T> {
        let map: [Tag:PartialKeyPath<T>]
    }
    
    static var fieldMap: FieldMap = {
        let paths: [Tag:PartialKeyPath<Self>] = [
        "HEDR": \.info,
        "CNAM": \.author,
        "SNAM": \.desc,
        "MAST": \.masters,
        "DATA": \.masterData,
        "INTV": \.tagifiedStringCount,
        "INTC": \.unknownCounter
        ]

        let nuMap = FieldMap(paths: paths)

        print(oldMap.byTag.map({ key, value in "\(key): \(value.type) \(value.name)" }).sorted())
        print(nuMap.byTag.map({ key, value in "\(key): \(value.type) \(value.name)" }).sorted())

        let decoder = MappingDecoder()
        let mapping = decoder.decode(Self.self)
        print(decoder.map)
        
        return nuMap
    }()

    static var oldMap: FieldMap {
        let map: FieldMap = [
            "HEDR": .init("info", TES4Header.self),
            "CNAM": .string("author"),
            "SNAM": .string("desc"),
            "MAST": .init("masters", String.self),
            "DATA": .init("unusedData", UInt64.self),
            "INTV": .init("tagifiedStringCount", UInt32.self),
            "INTC": .init("unknownCounter", UInt32.self)
        ]

        return map
    }
}

//extension PartialKeyPath {
//    var dearrayedType: Any.Type {
//        Self.valueType
//    }
//}

protocol P1 {
    var dearrayedType: Any.Type { get }
}

protocol ArrayMarker {
    static var et: Any.Type { get }
}

extension Array: ArrayMarker {
    static var et: Any.Type { Element.self }
}

extension Optional: ArrayMarker {
    static var et: Any.Type { Wrapped.self }
}

extension KeyPath: P1 where Value: ArrayMarker {
    var dearrayedType: Any.Type {
        print("dearrayed \(Value.self) to \(Value.et)")
        return Value.et
    }
}

extension KeyPath {
    
}
protocol DeArray {
    func dearray(_ type: Any.Type) -> Decodable.Type
}

extension Array: DeArray where Element: Decodable {
    func dearray(_ type: Any.Type) -> Decodable.Type {
        return Element.self
    }
}


//func dearray<T: Decodable>(_ type: Array<T>.Type) -> Any.Type {
//    return T.self
//}

extension TES4Record: CustomStringConvertible {
    var description: String {
        return "«TES4 \(info.version)»"
    }
}
//
//@propertyWrapper
//struct FX<Value: Codable>: Codable  {
//    let value: Value
//
//    init(
//    init(_ tag: Tag) {
//        self.value = value
//    }
//
//    init(wrappedValue value: Value) {
//        self.value = value
//    }
//
//    var wrappedValue: Value {
//        value
//    }
//}
