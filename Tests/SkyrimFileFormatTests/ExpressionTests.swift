// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import SkyrimFileFormat

class ExpressionTests: XCTestCase {
    func testBuilder() {
        let expression = Expression(function: 58, val: 1092616192, op: .equals, flags: [], parameters: [219994, 0])
        XCTAssertEqual(expression.rawValue, "GetStage(Form(0x35B5A)) == 10.0")

        
        /*
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 248, val: 0, op: .equals, flags: [], parameters: [220000, 0])
        XCTAssertEqual(expression.rawValue, "IsScenePlaying(unknown(67, "Scene ")) == 0.0")
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 629, val: 1065353216, op: .equals, flags: [], parameters: [219994, 0])
        XCTAssertEqual(expression.rawValue, "GetVMQuestVariable(quest: 219994, unknown(76, "VM Variable Name")) == 1.0")
        let expression = Expression(function: 654, val: 1065353216, op: .equals, flags: [], parameters: [0, 0])
        XCTAssertEqual(expression.rawValue, "GetBribeSuccess() == 1.0")
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 629, val: 0, op: .equals, flags: [], parameters: [219994, 2547345640])
        XCTAssertEqual(expression.rawValue, "GetVMQuestVariable(quest: 219994, unknown(76, "VM Variable Name")) == 0.0")
        let expression = Expression(function: 14, val: 857763, op: .greaterThanOrEqual, flags: [useGlobal], parameters: [17, 0])
        XCTAssertEqual(expression.rawValue, "GetActorValue(unknown(5, "Actor Value")) >= Form(857763)")
        let expression = Expression(function: 629, val: 0, op: .equals, flags: [], parameters: [219994, 2547345624])
        XCTAssertEqual(expression.rawValue, "GetVMQuestVariable(quest: 219994, unknown(76, "VM Variable Name")) == 0.0")
        let expression = Expression(function: 566, val: 1065353216, op: .equals, flags: [], parameters: [1, 0])
        XCTAssertEqual(expression.rawValue, "GetIsAliasRef(unknown(63, "QuestAlias")) == 1.0")
        let expression = Expression(function: 629, val: 1065353216, op: .equals, flags: [], parameters: [219994, 2547345616])
        XCTAssertEqual(expression.rawValue, "GetVMQuestVariable(quest: 219994, unknown(76, "VM Variable Name")) == 1.0")
        let expression = Expression(function: 14, val: 858451, op: .greaterThanOrEqual, flags: [useGlobal], parameters: [17, 0])
        XCTAssertEqual(expression.rawValue, "GetActorValue(unknown(5, "Actor Value")) >= Form(858451)")
        let expression = Expression(function: 629, val: 1065353216, op: .equals, flags: [], parameters: [219994, 2547345576])
        XCTAssertEqual(expression.rawValue, "GetVMQuestVariable(quest: 219994, unknown(76, "VM Variable Name")) == 1.0")
         */
    }
}

