// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import BinaryCoding


struct ConditionField: Codable {
    public enum CodingKeys: CodingKey {
        case test
        case flags
    }

    let raw: RawConditionField
    
    init(from decoder: Decoder) throws {
        let test: String
        let flags: ConditionFlags
        
        if let container = try? decoder.container(keyedBy: Self.CodingKeys) {
            flags = try container.decode(ConditionFlags.self, forKey: .flags)
            test = try container.decode(String.self, forKey: .test)
        } else {
            var container = try decoder.unkeyedContainer()
            flags = []
            test = try container.decode(String.self)
        }
        
        let expression = ConditionExpression(rawValue: test)
        guard let expression = expression.parse(flags: flags) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Couldn't decode expression"))
            
        }
        
        self.raw = RawConditionField(flags: flags, expression: expression)
    }

    func encode(to encoder: Encoder) throws {
        let expression = ConditionExpression(from: raw.expression)
        if !raw.flags.isEmpty {
            var container = encoder.container(keyedBy: Self.CodingKeys)
            try container.encode(expression.rawValue, forKey: .test)
            try container.encode(raw.flags, forKey: .flags)
        } else {
            var container = encoder.unkeyedContainer()
            try container.encode(expression.rawValue)
        }
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

struct RawConditionField: BinaryCodable {
    let opCode: UInt8
    let padding1: Padding3
    let value: UInt32
    let function: UInt16
    let padding2: UInt16
    let param1: UInt32
    let param2: UInt32
    let runOn: ConditionTarget
    let reference: FormID
    let unknown: UInt32
    
    init(flags: ConditionFlags, expression: RawExpression) {
        self.opCode = expression.comparison.flags | flags.rawValue
        self.padding1 = Padding3()
        self.value = expression.value
        self.function = expression.function
        self.padding2 = 0
        self.param1 = expression.parameters[0]
        self.param2 = expression.parameters[1]
        self.runOn = expression.runOn
        self.reference = FormID() // TODO:
        self.unknown = 0
    }
    
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
    
    var expression: RawExpression {
        return .init(function: function, value: value, comparison: op, flags: flags, parameters: params, runOn: runOn)
    }
}

public struct RawExpression {
    let function: UInt16
    let value: UInt32
    let comparison: ComparisonOperator
    let flags: ConditionFlags
    let parameters: [UInt32]
    let runOn: ConditionTarget

    public init(function: UInt16, value: UInt32, comparison: ComparisonOperator, flags: ConditionFlags, parameters: [UInt32], runOn: ConditionTarget) {
        self.function = function
        self.value = value
        self.comparison = comparison
        self.flags = flags
        self.parameters = parameters
        self.runOn = runOn
    }
}

extension RawExpression: Equatable { }
