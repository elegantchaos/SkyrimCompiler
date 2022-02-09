// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

protocol ProcessorProtocol {
    associatedtype BaseIterator: AsyncIteratorProtocol where BaseIterator.Element == Byte
    typealias Iterator = AsyncBufferedIterator<BaseIterator>
    var processor: Processor { get }
}

extension ProcessorProtocol {
    var configuration: Configuration { processor.configuration }
}

protocol RecordSequence: AsyncSequence where Element == Record {
}

extension AsyncThrowingIteratorMapSequence: RecordSequence where Element == Record {
}

class Processor {
    internal init(configuration: Configuration) {
        self.configuration = configuration
        self.encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
    }
    
    let configuration: Configuration
    let encoder: JSONEncoder
    
    
    
    func records<I: AsyncByteSequence>(bytes: I) -> AsyncThrowingIteratorMapSequence<I, Record> {
        let records = bytes.iteratorMap { iterator -> Record in
            let stream = AsyncDataStream(iterator: iterator)
            let header = try await RecordHeader(stream)
            let data = try await header.payload(stream) // TODO: allow the payload read to be deferred
            iterator = stream.iterator
            return try await Record(header: header, data: data)
        }

        return records
    }

    func realisedRecords<I: AsyncByteSequence>(bytes: I, processChildren: Bool) -> RealisedRecordSequence<I> {
        let records = RealisedRecordSequence(data: bytes, processor: self, processChildren: processChildren)
        return records
    }

    
    func fields<I>(bytes: inout I, types: FieldsMap) -> AsyncThrowingIteratorMapSequence<I, Field> where I: AsyncSequence, I.Element == Byte {
        let sequence = bytes.iteratorMap { iterator -> Field in
            let header = try await Field.Header(&iterator)
            let data = try await iterator.next(bytes: Bytes.self, count: Int(header.size))
            return try await self.inflate(header: header, data: data, types: types)
        }
        
        return sequence
    }
    
    func inflate(header: Field.Header, data: Bytes, types: FieldsMap) async throws -> Field {
        do {
            if let kind = types[header.type]?.field {
                let decoder = FieldDecoder(header: header, data: data)
                let unpacked = try kind.init(from: decoder)
                return Field(header: header, value: unpacked)
            }
        } catch {
            print("Error unpacking \(header.type). Falling back to basic field.\n\n\(error)")
        }
        
        return Field(header: header, value: data)
    }

    
    func pack<I: AsyncByteSequence>(bytes: I, to url: URL) async throws {
        let records = records(bytes: bytes)
        var index = 0
        for try await record in records {
            do {
                let label = (record.header.id == 0) ? record.name : String(format: "%@-%08X", record.name, record.header.id)
                let name = String(format: "%04d %@", index, label)
                let recordURL = url.appendingPathComponent(name)
                if record.isGroup {
                    try await export(group: record, asJSONTo: recordURL)
                } else {
                    try await export(record: record, asJSONTo: recordURL)
                }
            } catch {
                print(error)
            }
            index += 1
        }
    }

    
    func export(record: Record, asJSONTo url: URL) async throws {
        let header = record.header
        let map = try configuration.fields(forRecord: header.type.description)
        let fp = FieldProcessor(map)
        try await fp.process(data: record.data, processor: self)

        let packed: RecordProtocol.Type = configuration.records[header.type] ?? PackedRecord.self
        let encoded = try packed.asJSON(header: header, fields: fp, with: self)
        try encoded.write(to: url.appendingPathExtension("json"), options: .atomic)
    }
    
    
    func export(group: Record, asJSONTo url: URL) async throws {
        let groupURL = url.appendingPathExtension("epsg")
        try FileManager.default.createDirectory(at: groupURL, withIntermediateDirectories: true)
        
        let header = UnpackedHeader(group.header)
        let headerURL = groupURL.appendingPathComponent("header.json")
        let encoded = try encoder.encode(header)
        try encoded.write(to: headerURL, options: .atomic)

        let childrenURL = groupURL.appendingPathComponent("records")
        try FileManager.default.createDirectory(at: childrenURL, withIntermediateDirectories: true)

        try await pack(bytes: group.data.asyncBytes, to: childrenURL)
    }
}

