// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import SkyrimFileFormat

extension RawExpression {
    static let rawVMQuest = RawExpression(function: 629, value: 0, comparison: .equals, flags: [], parameters: [219994, 2547345624], runOn: .subject)
    static let rawGetStage = RawExpression(function: 58, value: 1092616192, comparison: .equals, flags: [], parameters: [219994, 0], runOn: .subject)
    static let rawGetIsAliasRef = RawExpression(function: 566, value: 1065353216, comparison: .equals, flags: [], parameters: [1, 0], runOn: .subject)
    static let rawIsScenePlaying = RawExpression(function: 248, value: 0, comparison: .equals, flags: [], parameters: [220000, 0], runOn: .subject)
    static let rawGetBribeSuccess = RawExpression(function: 654, value: 1065353216, comparison: .equals, flags: [], parameters: [0, 0], runOn: .subject)
    static let rawGetActorValue = RawExpression(function: 14, value: 857763, comparison: .greaterThanOrEqual, flags: [.useGlobal], parameters: [17, 0], runOn: .subject)
}

class ExpressionBuildingTests: XCTestCase {
    
    func testGetVMQuestVariable() {
        let expression = ConditionExpression(from: .rawVMQuest)
        XCTAssertEqual(expression.rawValue, "Subject.GetVMQuestVariable(0x035B5A, Variable(0x97D568D8)) == 0.0")
    }
    
    func testGetStage() {
        let expression = ConditionExpression(from: .rawGetStage)
        XCTAssertEqual(expression.rawValue, "Subject.GetStage(0x035B5A) == 10.0")
    }
    
    func testGetIsAliasRef() {
        let expression = ConditionExpression(from: .rawGetIsAliasRef)
        XCTAssertEqual(expression.rawValue, "Subject.GetIsAliasRef(0x1) == 1.0")
    }
     
    func testIsScenePlaying() {
        let expression = ConditionExpression(from: .rawIsScenePlaying)
        XCTAssertEqual(expression.rawValue, "Subject.IsScenePlaying(0x035B60) == 0.0")
    }
    
    func testGetBribeSuccess() {
        let expression = ConditionExpression(from: .rawGetBribeSuccess)
        XCTAssertEqual(expression.rawValue, "Subject.GetBribeSuccess() == 1.0")
    }
    
    func testGetActorValue() {
        let expression = ConditionExpression(from: .rawGetActorValue)
        XCTAssertEqual(expression.rawValue, "Subject.GetActorValue(17) >= Global(0x0D16A3)")
    }
}

class ExpressionParsingTests: XCTestCase {
    
    func testGetVMQuestVariable() {
        let expression = ConditionExpression(rawValue: "Subject.GetVMQuestVariable(0x035B5A, Variable(0x97D568D8)) == 0.0")
        let raw = expression.parse(flags: [])
        XCTAssertEqual(raw, .rawVMQuest)
    }

    func testGetStage() {
        let expression = ConditionExpression(rawValue: "Subject.GetStage(0x035B5A) == 10.0")
        let raw = expression.parse(flags: [])
        XCTAssertEqual(raw, .rawGetStage)
    }
    
    func testGetIsAliasRef() {
        let expression = ConditionExpression(rawValue: "Subject.GetIsAliasRef(0x1) == 1.0")
        let raw = expression.parse(flags: [])
        XCTAssertEqual(raw, .rawGetIsAliasRef)
    }
     
    func testIsScenePlaying() {
        let expression = ConditionExpression(rawValue: "Subject.IsScenePlaying(0x035B60) == 0.0")
        let raw = expression.parse(flags: [])
        XCTAssertEqual(raw, .rawIsScenePlaying)
    }
    
    func testGetBribeSuccess() {
        let expression = ConditionExpression(rawValue: "Subject.GetBribeSuccess() == 1.0")
        let raw = expression.parse(flags: [])
        XCTAssertEqual(raw, .rawGetBribeSuccess)
    }
    
    func testGetActorValue() {
        let expression = ConditionExpression(rawValue: "Subject.GetActorValue(17) >= Global(0x0D16A3)")
        let raw = expression.parse(flags: [.useGlobal])
        XCTAssertEqual(raw, .rawGetActorValue)
    }

}

