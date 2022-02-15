// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Bytes
import Foundation

protocol DataStream {
    func read<T>(_ type: T.Type) async throws -> T where T: FixedWidthInteger
    func read(count: Int) async throws -> Bytes
}

extension DataStream {
    func read<T>(_ type: T.Type, not: T) async throws -> T? where T: FixedWidthInteger {
        let value = try await read(type)
        return value != not ? value : nil
    }

    func readNonZero<T>(_ type: T.Type) async throws -> T? where T: FixedWidthInteger {
        return try await read(type, not: 0)
    }
}
