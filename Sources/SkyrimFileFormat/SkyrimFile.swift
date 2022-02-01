// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import AsyncSequenceReader
import Bytes

// https://en.uesp.net/wiki/Skyrim_Mod:Mod_File_Format

struct SkyrimFile {
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    typealias Action = (TES4Record) -> ()
    
    func process(action: @escaping Action) async {
        let sequence = url.resourceBytes
        do {
            try await process(sequence, action: action)
        } catch {
            print(error)
        }
    }
    
    func process(_ bytes: URL.AsyncBytes, action: @escaping Action) async throws {
        let records = bytes.iteratorMap { iterator -> TES4Record in
            return try await TES4Record(&iterator)
        }
        
        for try await record in records {
            action(record)
        }
    }
    
//
//
//            guard let payloadCountBytes = try await iterator.count(4) else { throw DataFrameError.missingPayloadSize }
//            var payloadSize = try UInt32(bigEndianBytes: payloadCountBytes)
//
//            guard let commandBytes = try await iterator.count(upToExcluding: 0, throwsIfOver: min(256, payloadSize)) else { throw DataFrameError.missingCommand }
//            let commandString = String(utf8Bytes: commandBytes)
//            payloadSize -= commandBytes.count - 1 // Don't forget the null byte we skipped
//
//            guard let payloadBytes = try await iterator.count(payloadSize) else { throw DataFrameError.missingPayload }
//
//            return DataFrame(command: commandString, payload: payloadBytes)
//        }
//
//        // Do something with the results:
//        for await dataFrame in results {
//            print(dataFrame)
//        }
//    }
}

enum SkyriFileError: Error {
    case badTag
}

extension InputStream {
    func readTag() throws -> String {
        var buffer = [UInt8].init(repeating: 0, count: 4)
        let result = read(&buffer, maxLength: 4)
        guard result == 4 else { throw SkyriFileError.badTag }
        guard let string = String(bytes: buffer, encoding: .ascii) else { throw SkyriFileError.badTag }
        return string
    }
    
    func readUInt32() throws -> UInt32 {
        return 0
    }
}

struct TES4Record {
    let type: String
    let size: UInt32
    let flags: UInt32
    let id: UInt32
    let timestamp: UInt16
    let versionInfo: UInt16
    let version: UInt16
    let unused: UInt16
    let data: [UInt8]
    
    init(_ iterator: inout AsyncBufferedIterator<URL.AsyncBytes.AsyncIterator>) async throws {
        let bytes = try await iterator.next(bytes: [UInt8].self, count: 4)
        guard let type = String(bytes: bytes, encoding: .ascii) else { throw SkyriFileError.badTag}
        self.type = type
        
        self.size = try await iterator.next(littleEndian: UInt32.self)
        self.flags = try await iterator.next(littleEndian: UInt32.self)
        self.id = try await iterator.next(littleEndian: UInt32.self)
        self.timestamp = try await iterator.next(littleEndian: UInt16.self)
        self.versionInfo = try await iterator.next(littleEndian: UInt16.self)
        self.version = try await iterator.next(littleEndian: UInt16.self)
        self.unused = try await iterator.next(littleEndian: UInt16.self)
        self.data = try await iterator.next(bytes: [UInt8].self, count: Int(size))
    }
}

struct TEST4Header {
    
}
