// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AsyncSequenceReader
import Bytes
import Foundation

//struct RecordSequence<I: AsyncByteSequence>: AsyncSequence {
//    typealias AsyncIterator = RecordIterator
//    typealias Element = RecordProtocol
//
//    let data: I
//    let processor: Processor
//    let processChildren: Bool
//
//    func makeAsyncIterator() -> AsyncIterator {
//        let recordDataIterator = WrappedRecordDataIterator(iterator: processor.recordData(bytes: data).makeAsyncIterator())
//        return RecordIterator(recordDataIterator, processor: processor, processChildren: processChildren)
//    }
//}

//class RecordIterator: AsyncIteratorProtocol {
//    var recordData: RecordDataIterator
//    let processor: Processor
//    let processChildren: Bool
//
//    init(_ root: RecordDataIterator, processor: Processor, processChildren: Bool) {
//        self.recordData = root
//        self.processor = processor
//        self.processChildren = processChildren
//    }
//
//    func next() async throws -> RecordProtocol? {
//        guard let record = try await recordData.next() else { return nil }
//
//        do {
//            let header = record.header
//            if processChildren && record.isGroup {
//                var children: [RecordProtocol] = []
//                let r = processor.recordData(bytes: record.data.asyncBytes)
//                let childRecordIterator = WrappedRecordDataIterator(iterator: r.makeAsyncIterator())
//                let childIterator = RecordIterator(childRecordIterator, processor: processor, processChildren: processChildren)
//                while let child = try await childIterator.next() {
//                    children.append(child)
//                }
//                                
//                return GroupRecord(header: record.header, children: children)
//            } else {
//                let fields = try await processor.decodedFields(type: record.type, header: record.header, data: record.data)
//                let recordClass = processor.configuration.recordClass(for: record.type)
//                let decoder = RecordDecoder(header: header, fields: fields)
//                return try recordClass.init(from: decoder)
//            }
//        } catch {
//            print(error)
//            throw error
//        }
//    }
//    
//    typealias Element = RecordProtocol
//}

