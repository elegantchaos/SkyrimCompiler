// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

extension CodingKey {
    public var compactDescription: String {
        if let int = intValue {
            return "\(int)"
        } else {
            return stringValue
        }
    }
    
    public var description: String {
        compactDescription
    }
}

extension Array where Element == CodingKey {
    var compactDescription: String {
        return map { $0.compactDescription }.joined(separator: ".")
    }
}

protocol DescribableCodingKey: CodingKey {
}

extension DecodingError: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description: String
        
        switch self {
            case .typeMismatch(let type, let context):
                description = "Wrong type at: \(context.codingPath.compactDescription). "
                description += context.debugDescription

            case .keyNotFound(let key, let context):
                var path = context.codingPath
                path.append(key)
                description = "Data missing at: \(path.compactDescription)."
                if let underlying = context.underlyingError {
                    description.append("\n\n\(underlying)")
                }

            default:
                description = self.localizedDescription
                let mirror = Mirror(reflecting: self)
                for (label, value) in mirror.children {
                    description.append("\n\(label ?? ""): \(value)")
                }
                break
        }

        return description
    }
}
//
//extension DecodingError.Context: CustomStringConvertible {
//    public var description: String {
//        return "path: \(codingPath.compactDescription)\n\(debugDescription)"
////        codingPath
//    }
//}
