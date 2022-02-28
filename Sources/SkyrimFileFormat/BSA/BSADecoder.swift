// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

class BSADecoder: DataDecoder {
    var header: BSAHeader?
}

extension Decoder {
    var decodeBSAFileNames: Bool {
        guard let decoder = self as? BSADecoder else { return false }
        guard let header = decoder.header else { return false }
        return header.flags.contains2(.includeFileNames)
    }

    var decodeBSADirectoryNames: Bool {
        guard let decoder = self as? BSADecoder else { return false }
        guard let header = decoder.header else { return false }
        return header.flags.contains2(.includeDirectoryNames)
    }
    
    var isBSACompressed: Bool {
        guard let decoder = self as? BSADecoder else { return false }
        guard let header = decoder.header else { return false }
        return header.flags.contains2(.compressed)
    }

}
