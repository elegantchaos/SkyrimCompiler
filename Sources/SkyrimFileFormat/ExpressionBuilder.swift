//
//  File.swift
//  
//
//  Created by Sam Deane on 08/03/2022.
//

import Foundation

public struct Expression: RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(function: UInt16, val: UInt32, op: ComparisonOperator, flags: ConditionFlags, parameters rawParameters: [UInt32]) {
        let value: String
        if flags.contains2(.useGlobal) {
            let form = FormID(id: val)
            value = form.expressionValue
        } else {
            let float = Float32(bitPattern: val)
            value = "\(float)"
        }

        let index = FunctionIndex.instance
        if let f = index.function(for: function) {
            var parameters = rawParameters
            var args: [String] = []
            for arg in f.arguments {
                switch arg {
                    case .integer(let name):
                        let raw = parameters.removeFirst()
                        args.append(name.map({ "\($0): \(raw)" }) ?? "\(raw)")

                    case .float(let name):
                        let raw = Float32(bitPattern: parameters.removeFirst())
                        args.append(name.map({ "\($0): \(raw)" }) ?? "\(raw)")

                    case .variable:
                        let raw = parameters.removeFirst()
                        args.append(String(format: "\(arg.cast)(0x%0X)", raw))

                    case .questAlias:
                        // TODO: look up quest alias and use name?
                        let raw = parameters.removeFirst()
                        args.append(String(format: "0x%0X", raw))
                        
                    case .quest, .scene:
                        let raw = parameters.removeFirst()
                        let form = FormID(id: raw)
                        args.append(form.expressionValue)
                        
                    default:
                        let raw = parameters.removeFirst()
                        args.append("\(raw)")
                }
            }
            
            self.rawValue = "\(f.name)(\(args.joined(separator: ", "))) \(op.keyword) \(value)"
        } else {
            let name = "UnknownFunc<\(function + 4096)>"
            let params = rawParameters.map({"\($0)"}).joined(separator: ", ")
            self.rawValue = "\(name)(\(params)) \(op.keyword) \(value)"
        }
        
        print("let expression = Expression(function: \(function), val: \(val), op: .\(op), flags: [\(flags)], parameters: \(rawParameters))")
        print("XCTAssertEqual(expression.rawValue, \"\(self.rawValue)\")")
    }
}
