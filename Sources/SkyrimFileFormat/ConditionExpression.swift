// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Expressions
import Foundation
import Logger

let expressionTestChannel = Channel("Expression Tests")


public struct ConditionExpression: RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(from raw: RawExpression) {
        let formattedValue: String
        let prefix = raw.runOn.conditionPrefix

        if raw.flags.contains2(.useGlobal) {
            let form = FormID(id: raw.value)
            if form.name.isEmpty {
                formattedValue = String(format: "Global(0x%06X)", form.id)
            } else {
                formattedValue = form.expressionValue
            }
        } else {
            let float = Float32(bitPattern: raw.value)
            formattedValue = "\(float)"
        }

        let index = FunctionIndex.instance
        if let f = index.function(for: raw.function) {
            var parameters = raw.parameters
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
            
            self.rawValue = "\(prefix).\(f.name)(\(args.joined(separator: ", "))) \(raw.comparison.keyword) \(formattedValue)"
        } else {
            let name = "UnknownFunc<\(raw.function + 4096)>"
            let params = raw.parameters.map({"\($0)"}).joined(separator: ", ")
            self.rawValue = "\(prefix).\(name)(\(params)) \(raw.comparison.keyword) \(formattedValue)"
        }

        expressionTestChannel.debug("""
            
            let expression = Expression(from: RawExpression(function: \(raw.function), val: \(raw.value), op: .\(raw.comparison), flags: [\(raw.flags)], parameters: \(raw.parameters), runOn: .\(raw.runOn))")
            XCTAssertEqual(expression.rawValue, \"\(self.rawValue)\")"
            
            """
        )
    }
    
    public func parse(flags: ConditionFlags) -> RawExpression? {
        struct Capture {
            var destination = ""
            var function = ""
            var arguments = ""
            var op = ""
            var value = ""
        }
        
        let pattern = #"(\w+)\.(\w+)\((.*)\) (==|!=|<|>|<=|>=) (.*)"#
        let regex = try! NSRegularExpression(pattern: pattern)
        
        var result = Capture()
        if regex.firstMatch(in: rawValue, capturing: [\Capture.destination: 1, \.function: 2, \.arguments: 3, \.op: 4, \.value: 5], into: &result) {
            print(result)
        }

        guard let destination = ConditionTarget(result.destination),
              let function = FunctionIndex.instance.function(for: result.function),
              let value = Float(result.value),
              let comparison =  ComparisonOperator(keyword: result.op)
        else {
            return nil
        }
        
        var argValues = result.arguments.split(separator: ",").map({ String($0) })
        var parameters: [UInt32] = []
        for param in function.arguments {
            let string = argValues.removeFirst().trimmingCharacters(in: .whitespaces)
            parameters.append(param.raw(from: string))
        }
        
        return RawExpression(function: UInt16(function.id - 4096), value: value.bitPattern, comparison: comparison, flags: flags, parameters: parameters, runOn: destination)
    }
        
}

