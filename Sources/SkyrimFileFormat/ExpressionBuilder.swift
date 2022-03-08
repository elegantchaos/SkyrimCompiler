// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Logger

let expressionTestChannel = Channel("Expression Tests")

public struct Expression: RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(function: UInt16, value: UInt32, comparison: ComparisonOperator, flags: ConditionFlags, parameters rawParameters: [UInt32], runOn: ConditionTarget) {
        let formattedValue: String
        let prefix = runOn.conditionPrefix

        if flags.contains2(.useGlobal) {
            let form = FormID(id: value)
            if form.name.isEmpty {
                formattedValue = String(format: "Global(0x%06X)", form.id)
            } else {
                formattedValue = form.expressionValue
            }
        } else {
            let float = Float32(bitPattern: value)
            formattedValue = "\(float)"
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
            
            self.rawValue = "\(prefix).\(f.name)(\(args.joined(separator: ", "))) \(comparison.keyword) \(formattedValue)"
        } else {
            let name = "UnknownFunc<\(function + 4096)>"
            let params = rawParameters.map({"\($0)"}).joined(separator: ", ")
            self.rawValue = "\(prefix).\(name)(\(params)) \(comparison.keyword) \(formattedValue)"
        }

        expressionTestChannel.debug("""
            
            let expression = Expression(function: \(function), val: \(value), op: .\(comparison), flags: [\(flags)], parameters: \(rawParameters), runOn: .\(runOn)")
            XCTAssertEqual(expression.rawValue, \"\(self.rawValue)\")"
            
            """
        )
    }
}
