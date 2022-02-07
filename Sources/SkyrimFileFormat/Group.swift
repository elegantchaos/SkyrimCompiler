// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

class Group: Record {
    enum GroupType: UInt32 {
        case top
        case worldChildren
        case interiorCellBlock
        case interiorCellSubBlock
        case exteriorCellBlock
        case exteriorCellSubBlock
        case cellChildren
        case topicChildren
        case cellPersistentChildren
        case cellTemporaryChildren
    }
    
    let groupType: GroupType

    required init(header: RecordHeader, data: Bytes, processor: ProcessorProtocol) async throws {
        guard let groupType = GroupType(rawValue: header.id) else { throw SkyrimFileError.badGroupType }
        self.groupType = groupType
        try await super.init(header: header, data: data, processor: processor)
    }
    
    var recordType: Tag? {
        switch groupType {
            case .top:
                return Tag(header.flags)
                
            default:
                return nil
        }
    }
    
    override var childData: BytesAsyncSequence {
        return data.asyncBytes
    }

    var contentName: String {
        if let type = recordType {
            return "\(type)"
        } else {
            return "\(groupType)"
        }
    }

    override var description: String {
        return "«group of \(contentName) records»"
    }
    
    override var name: String {
        contentName
    }
    
    override func pack(to url: URL, processor: Processor) async throws {
        let groupURL = url.appendingPathExtension("epsg")
        try FileManager.default.createDirectory(at: groupURL, withIntermediateDirectories: true)
        
        let headerURL = groupURL.appendingPathComponent("header.json")
        let header = PackedHeader(header)
        let encoded = try JSONEncoder().encode(header)
        try encoded.write(to: headerURL, options: .atomic)

        let childrenURL = groupURL.appendingPathComponent("records")
        try FileManager.default.createDirectory(at: childrenURL, withIntermediateDirectories: true)

        try await processor.pack(bytes: childData, to: childrenURL)
    }
}
