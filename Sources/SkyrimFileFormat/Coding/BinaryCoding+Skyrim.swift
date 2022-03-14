//
//  File.swift
//  
//
//  Created by Sam Deane on 14/03/2022.
//

import Foundation
import BinaryCoding

extension BinaryDecoder {
    var skyrimStringEncoding: String.Encoding {
        String.Encoding.windowsCP1252 // TODO: possibly read this from userInfo
    }
}

extension BinaryEncoder {
    var skyrimStringEncoding: String.Encoding {
        String.Encoding.windowsCP1252 // TODO: possibly read this from userInfo
    }
}
