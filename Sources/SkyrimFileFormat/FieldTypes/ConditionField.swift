// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import BinaryCoding

struct Function: RawRepresentable, BinaryCodable {
    let rawValue: UInt16
    
    static let GetEventData = Self(rawValue: 4672)
}

struct ConditionField: BinaryCodable {
    let op: UInt8
    let value: FormIDOrFloat
    let function: Function
    let parameters: [UInt32]
    let runOnType: UInt32
    let reference: FormID
    let unknown: UInt32
    
    init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        self.op = try container.decode(UInt8.self)
        self.value = try container.decode(FormIDOrFloat.self)
        let _ = try container.decode(Padding3.self)
        let code = try container.decode(UInt16.self)
        self.function = Function(rawValue: code + 4096)
        let _ = try container.decode(UInt16.self)
        var parameters: [UInt32] = []
        if function == .GetEventData {
            parameters.append(UInt32(try container.decode(UInt16.self)))
            parameters.append(UInt32(try container.decode(UInt16.self)))
            parameters.append(try container.decode(UInt32.self))
        } else {
            parameters.append(try container.decode(UInt32.self))
            parameters.append(try container.decode(UInt32.self))
        }
        self.parameters = parameters

        self.runOnType = try container.decode(UInt32.self)
        self.reference = try container.decode(FormID.self)
        self.unknown = try container.decode(UInt32.self)
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(op)
        try container.encode(Padding3())
        try container.encode(value)
        try container.encode(function)
        try container.encode(UInt16(0))
        if function == .GetEventData {
                try container.encode(UInt16(parameters[0]))
                try container.encode(UInt16(parameters[1]))
                try container.encode(parameters[2])
        } else {
                for param in parameters {
                    try container.encode(param)
                }
        }
        try container.encode(runOnType)
        try container.encode(reference)
        try container.encode(unknown)

    }
}

struct FormIDOrFloat: BinaryCodable {
    let raw: UInt32
}

struct FormIDOrInt: BinaryCodable {
    let raw: UInt32
}
