// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/02/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct ESPBundle {
    typealias Index = [Tag:[RecordProtocol]]
    var records: [RecordProtocol]
    var index: Index
    var count: Int { records.count }
    var header: TES4Record? {
        records.first(where: { $0.type == TES4Record.tag }) as? TES4Record
    }
    
    init(records: [RecordProtocol]) {
        var index = Index()
        for record in records {
            var list = index[record.type] ?? []
            list.append(record)
            index[record.type] = list
        }
        
        self.records = records
        self.index = index
    }
}
