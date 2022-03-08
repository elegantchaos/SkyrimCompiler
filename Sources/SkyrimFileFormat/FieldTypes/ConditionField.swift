// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import BinaryCoding


enum Operator: String, BinaryCodable, CaseIterable {
    case equals
    case notEquals
    case greaterThan
    case greaterThanOrEqual
    case lessThan
    case lessThanOrEqual
}

struct ConditionFlags: OptionSetFromEnum {
    public enum Options: String, EnumForOptionSet {
        case or
        case useAliases
        case useGlobal
        case usePackData
        case swapSubjectAndTarget
    }
    
    public let rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

struct ConditionField: BinaryCodable {
    let op: Operator
    let flags: ConditionFlags?
    let value: Float32?
    let global: FormID?
    let function: String?
    
//    let value: FormIDOrFloat
//    let function: Function
//    let parameters: [UInt32]
//    let runOnType: UInt32
//    let reference: FormID
//    let unknown: UInt32
    
    init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        let raw = try container.decode(RawConditionField.self)
        
        self.op = Operator.allCases[Int(raw.op >> 5)]
        let flags = ConditionFlags(rawValue: raw.op & 0x1F)
        self.flags = flags.rawValue != 0 ? flags : nil
        
        if flags.contains2(.useGlobal) {
            value = nil
            global = FormID(id: raw.value)
        } else {
            value = Float32(bitPattern: raw.value)
            global = nil
        }

        if let f = functions[raw.function + 4096] {
            self.function = f
        } else {
            self.function = "\(raw.function + 4096)"
        }
        
    //        let code = try container.decode(UInt16.self)
//        self.function = Function(rawValue: code + 4096)
//        let _ = try container.decode(UInt16.self)
//        var parameters: [UInt32] = []
//        if function == .GetEventData {
//            parameters.append(UInt32(try container.decode(UInt16.self)))
//            parameters.append(UInt32(try container.decode(UInt16.self)))
//            parameters.append(try container.decode(UInt32.self))
//        } else {
//            parameters.append(try container.decode(UInt32.self))
//            parameters.append(try container.decode(UInt32.self))
//        }
//        self.parameters = parameters
//
//        self.runOnType = try container.decode(UInt32.self)
//        self.reference = try container.decode(FormID.self)
//        self.unknown = try container.decode(UInt32.self)
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        let index = Operator.allCases.firstIndex(of: op)!
        let rawOp = (UInt8(index) << 5) | (flags?.rawValue ?? 0)
        let raw = RawConditionField(op: rawOp, padding1: Padding3(), value: 0, function: 0, padding2: 0, param1: 0, param2: 0, runOnType: 0, reference: FormID(), unknown: 0)
        var container = encoder.unkeyedContainer()
        try container.encode(raw)
//        try container.encode(op)
//        try container.encode(Padding3())
//        try container.encode(value)
//        try container.encode(function)
//        try container.encode(UInt16(0))
//        if function == .GetEventData {
//                try container.encode(UInt16(parameters[0]))
//                try container.encode(UInt16(parameters[1]))
//                try container.encode(parameters[2])
//        } else {
//                for param in parameters {
//                    try container.encode(param)
//                }
//        }
//        try container.encode(runOnType)
//        try container.encode(reference)
//        try container.encode(unknown)

    }
}

struct FormIDOrFloat: BinaryCodable {
    let raw: UInt32
}

struct FormIDOrInt: BinaryCodable {
    let raw: UInt32
}

struct RawConditionField: BinaryCodable {
    let op: UInt8
    let padding1: Padding3
    let value: UInt32
    let function: UInt16
    let padding2: UInt16
    let param1: UInt32
    let param2: UInt32
    let runOnType: UInt32
    let reference: FormID
    let unknown: UInt32
}

let functions: [UInt16:String] = [
    4168: "GetIsID",
    4154: "GetStage",
    4158: "GetQuestRunning",
    4672: "GetEventData"
]
