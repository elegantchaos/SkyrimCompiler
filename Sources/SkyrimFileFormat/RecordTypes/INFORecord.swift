// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BinaryCoding
import Foundation

struct INFORecord: RecordProtocol {
    static var tag = Tag("INFO")

    let _meta: RecordMetadata

    let editorID: String?
    let data: DATAField?
    let enam: ENAMField?
    let previousInfo: FormID?
    let favourLevel: UInt8
    let topicLinks: [FormID]
    let sharedInfo: FormID?
    let responses: [ResponseField]
    let responseText: [UInt32]
    let responseNotes: [String]
    let responseEdits: [String]
    let responseSpeakerIdeAnims: [FormID]
    let responseListenerIdleAnims: [FormID]
    let conditions: [ConditionField]
    let response: String?
    let speaker: FormID?
    let walkAwayTopic: FormID?
    let audioOutputOverride: FormID?
    
    static var fieldMap = FieldTypeMap(paths: [
        (CodingKeys.editorID, \Self.editorID, "EDID"),
        (.data, \.data, "DATA"),
        (.enam, \.enam, "ENAM"),
        (.previousInfo, \.previousInfo, "PNAM"),
        (.favourLevel, \.favourLevel, "CNAM"),
        (.topicLinks, \.topicLinks, "TCLT"),
        (.sharedInfo, \.sharedInfo, "DNAM"),
        (.responses, \.responses, "TRDT"),
        (.responseText, \.responseText, "NAM1"),
        (.responseNotes, \.responseNotes, "NAM2"),
        (.responseEdits, \.responseEdits, "NAM3"),
        (.responseSpeakerIdeAnims, \.responseSpeakerIdeAnims, "SNAM"),
        (.responseListenerIdleAnims, \.responseListenerIdleAnims, "LNAM"),
        (.conditions, \.conditions, "CTDA"),
        (.response, \.response, "RNAM"),
        (.speaker, \.speaker, "ANAM"),
        (.walkAwayTopic, \.walkAwayTopic, "TWAT"),
        (.audioOutputOverride, \.audioOutputOverride, "ONAM"),
    ])
    
    struct DATAField: BinaryCodable {
        let dialogueTab: UInt16
        let flags: UInt16
        let resetTime: Float32
    }
    
    struct ENAMField: BinaryCodable {
        let flags: UInt16
        let resetTime: UInt16
    }
    
    struct ResponseField: BinaryCodable {
        let emotionType: UInt32
        let emotionValue: UInt32
        let unknown1: UInt32
        let responseID: UInt8
        let junk1: Padding3
        let soundFile: FormID
        let useEmoAnim: UInt8
        let junk2: Padding3
    }
}


