// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol RecordProtocol: Codable {
    static var tag: Tag { get }
    func asJSON(with processor: Processor) throws -> Data
    static var fieldMap: FieldTypeMap { get }
    var _header: RecordHeader { get }
}

extension RecordProtocol {
    var header: RecordHeader { _header }

    func asJSON(with processor: Processor) throws -> Data {
        return try processor.jsonEncoder.encode(self)
    }
}

protocol IdentifiedRecord: RecordProtocol {
    var editorID: String { get }
}
