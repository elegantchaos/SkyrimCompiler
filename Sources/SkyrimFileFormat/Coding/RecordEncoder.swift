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
    var fieldOrder: [Tag]
    var encodedHeader: Data?
    var encodedFields: [Tag:[Data]]
    
    init(fields: FieldTypeMap, fieldOrder: [Tag]) {
        self.fieldMap = fields
        self.encodedFields = [:]
        self.encodedHeader = nil
        self.fieldOrder = fieldOrder
        super.init()
    }
    
    func pushHeader() {
        encodedHeader = data
        data = Data()
    }
    
    func pushField(_ tag: Tag) {
        var list = encodedFields[tag] ?? []
        list.append(data)
        encodedFields[tag] = list
        data = Data()
    }

    var orderedFieldData: Data {
        var data = Data()
        data.append(encodedHeader!) // if the header hasn't been written by now, something is badly wrong
        
        func writeFields(_ fieldTags: [Tag]) {
            for tag in fieldTags {
                if var list = encodedFields[tag], !list.isEmpty {
                    let field = list.removeFirst()
                    data.append(field)
                    if list.isEmpty {
                        encodedFields.removeValue(forKey: tag)
                    } else {
                        encodedFields[tag] = list
                    }
                } else {
                    print("expected field \(tag)")
                }
            }
        }
        
        // use any recorded field order
        writeFields(fieldOrder)
        
        if encodedFields.count > 0 {
            // try to use the map for any remaining fields
            for tag in fieldMap.tagOrder {
                if let entry = fieldMap.entry(forTag: tag) {
                    let group = entry.groupWith
                    writeFields(group)
                }
            }
        }
        
        if encodedFields.count > 0 {
            // encoded any remaining stuff in the order we find it
            for (_, list) in encodedFields {
                for field in list {
                    data.append(field)
                }
            }
        }
        
        return data
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
                    encoder.pushHeader()
                    
                    if let fields = meta.fields {
                        for (type,list) in fields {
                            for field in list {
                                if let data = field.hexData {
                                    let tag = Tag(type)
                                    let header = Field.Header(type: tag, size: UInt16(data.count))
                                    try encoder.writeEncodable(header)
                                    try encoder.writeEncodable(data)
                                    encoder.pushField(tag)
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
                        // TODO: can implement this as FieldCodableArray.binaryEncode now?
                        // if the type is an array, we need to write out each of its elements
                        // separately with the same field tag
                        for encoded in try array.elements(encodedWith: binaryEncoder) {
                            let header = Field.Header(type: tag, size: UInt16(encoded.count))
                            try encoder.writeEncodable(header)
                            try encoder.writeEncodable(encoded)
                            encoder.pushField(tag)
                        }
                        
                        
                    } else {
                        try value.binaryEncode(to: binaryEncoder)
                        let encoded = binaryEncoder.data
                        
                        let header = Field.Header(type: tag, size: UInt16(encoded.count))
                        try encoder.writeEncodable(header)
                        try encoder.writeEncodable(encoded)
                        encoder.pushField(tag)
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

