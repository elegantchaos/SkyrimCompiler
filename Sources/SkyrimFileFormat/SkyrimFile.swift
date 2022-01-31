// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/01/2022.
//  All code (c) 2022 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

// https://en.uesp.net/wiki/Skyrim_Mod:Mod_File_Format

struct SkyrimFile {
    let url: URL
    
    init(_ url: URL) {
        self.url = url
        
        do {
            if let input = InputStream(url: url) {
                input.open()
                let record = try TES4Record(input)
                print(record)
            }
        } catch {
            print(error)
        }
        
    }
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

    init(_ stream: InputStream) throws {
        self.type = try stream.readTag()
        self.size = try stream.readUInt32()
    }
}

struct TEST4Header {
    
}
