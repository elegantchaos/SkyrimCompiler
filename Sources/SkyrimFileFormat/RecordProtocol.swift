// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol RecordProtocol: Codable {
    static var tag: Tag { get }
    func asJSON(with processor: Processor) throws -> Data
    static func fromJSON(_ data: Data, with processor: Processor) throws -> RecordProtocol
    static var fieldMap: FieldTypeMap { get }
    var _header: RecordHeader { get }
}

extension RecordProtocol {
    var type: Tag { _header.type }
    
    var header: RecordHeader { _header }

    func asJSON(with processor: Processor) throws -> Data {
        return try processor.jsonEncoder.encode(self)
    }
    
    static func fromJSON(_ data: Data, with processor: Processor) throws -> RecordProtocol {
        let decoded = try processor.jsonDecoder.decode(Self.self, from: data)
        return decoded
    }
}

protocol IdentifiedRecord: RecordProtocol {
    var editorID: String { get }
}
