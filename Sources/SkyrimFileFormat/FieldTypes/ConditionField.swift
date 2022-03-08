// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import BinaryCoding


public struct ConditionFlags: OptionSetFromEnum {
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

struct ConditionField: Codable {
    public enum CodingKeys: CodingKey {
        case test
        case flags
    }

    let raw: RawConditionField
    
    init(from decoder: Decoder) throws {
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "not implemented yet"))
    }

    func encode(to encoder: Encoder) throws {
        let expression = Expression(function: raw.function, val: raw.value, op: raw.op, flags: raw.flags, parameters: raw.params)
        if raw.flags.rawValue != 0 {
            var container = encoder.container(keyedBy: Self.CodingKeys)
            try container.encode(expression.rawValue, forKey: .test)
            try container.encode(raw.flags, forKey: .flags)
        } else {
            var container = encoder.unkeyedContainer()
            try container.encode(expression.rawValue)
        }
    }
    
    var testString: String {
        let flags = raw.flags
        let op = raw.op
        
        let value: String
        if flags.contains2(.useGlobal) {
            let form = FormID(id: raw.value)
            value = "Form(\(form.id))"
        } else {
            let float = Float32(bitPattern: raw.value)
            value = "\(float)"
        }

        let expression = Expression(function: raw.function, val: raw.value, op: raw.op, flags: raw.flags, parameters: raw.params)
        return expression.rawValue
//        let index = FunctionIndex.instance
//        if let f = index.function(for: raw.function) {
//            var parameters = raw.params
//            var args: [String] = []
//            for arg in f.arguments {
//                switch arg {
//                    case .integer(let name):
//                        let raw = parameters.removeFirst()
//                        args.append(name.map({ "\($0): \(raw)" }) ?? "\(raw)")
//
//                    case .quest(let name):
//                        let raw = parameters.removeFirst()
//                        let label = name ?? "quest"
//                        args.append("\(label): \(raw)")
//
//                    default:
//                        args.append("\(arg)")
//                }
//            }
//
//            return "\(f.name)(\(args.joined(separator: ", "))) \(op.keyword) \(value)"
//        } else {
//            let name = "UnknownFunc<\(raw.function + 4096)>"
//            return "\(name)(\(raw.param1), \(raw.param2)) \(op.keyword) \(value)"
//        }
        
    }
    
}

extension ConditionField: BinaryCodable {
    init(fromBinary decoder: BinaryDecoder) throws {
        var container = try decoder.unkeyedContainer()
        self.raw = try container.decode(RawConditionField.self)
    }
    
    func binaryEncode(to encoder: BinaryEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(raw)

    }
}

struct FormIDOrFloat: BinaryCodable {
    let raw: UInt32
}

struct FormIDOrInt: BinaryCodable {
    let raw: UInt32
}

struct RawConditionField: BinaryCodable {
    let opCode: UInt8
    let padding1: Padding3
    let value: UInt32
    let function: UInt16
    let padding2: UInt16
    let param1: UInt32
    let param2: UInt32
    let runOnType: UInt32
    let reference: FormID
    let unknown: UInt32
    
    var params: [UInt32] {
        var parameters: [UInt32] = []
        
        if function == 4672 /* GetEventData */ {
            parameters.append(param1 & 0xFFFF)
            parameters.append(param1 >> 16)
        } else {
            parameters.append(param1)
        }
        
        parameters.append(param2)
        return parameters
    }
    
    var op: ComparisonOperator {
        return ComparisonOperator(flags: opCode)
    }
    
    var flags: ConditionFlags {
        return ConditionFlags(rawValue: opCode & 0x1F)
    }
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

//        let index = Operator.allCases.firstIndex(of: op)!
//        let rawOp = (UInt8(index) << 5) | (flags?.rawValue ?? 0)
//        let raw = RawConditionField(op: rawOp, padding1: Padding3(), value: 0, function: 0, padding2: 0, param1: 0, param2: 0, runOnType: 0, reference: FormID(), unknown: 0)
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


//    let value: FormIDOrFloat
//    let function: Function
//    let parameters: [UInt32]
//    let runOnType: UInt32
//    let reference: FormID
//    let unknown: UInt32
