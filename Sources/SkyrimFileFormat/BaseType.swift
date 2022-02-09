// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Conformance to this protocol indicates that the type encloses another type, and
/// provides a way to retrieve it.
///
/// "Enclosing" is a loose concept, which includes both collections and optionals.

protocol EnclosingType {
    static var baseType: Any.Type { get }
}

extension Array: EnclosingType {
    static var baseType: Any.Type { Element.self }
}

extension Optional: EnclosingType {
    static var baseType: Any.Type { Wrapped.self }
}

/// If a keypath's value type conforms, conform the protocol
extension KeyPath: EnclosingType where Value: EnclosingType {
    static var baseType: Any.Type {
        return Value.baseType
    }
}
