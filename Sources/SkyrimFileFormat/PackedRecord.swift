//
//  File.swift
//  
//
//  Created by Sam Deane on 07/02/2022.
//

import Foundation

struct PackedRecord: Codable {
    let header: PackedHeader
    let fields: [PackedField]
    
    init(_ header: Record.Header, fields: [Field]) {
        self.header = PackedHeader(header)
        self.fields = fields.map { PackedField($0) }
    }
}
