// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/03/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import SkyrimFileFormat

class ExpressionTests: XCTestCase {
    func testGetVMQuestVariable() {
        let expression = Expression(function: 629, value: 0, comparison: .equals, flags: [], parameters: [219994, 2547345624], runOn: .subject)
        XCTAssertEqual(expression.rawValue, "Subject.GetVMQuestVariable(0x035B5A, Variable(0x97D568D8)) == 0.0")
    }
    
    func testGetStage() {
        let expression = Expression(function: 58, value: 1092616192, comparison: .equals, flags: [], parameters: [219994, 0], runOn: .subject)
        XCTAssertEqual(expression.rawValue, "Subject.GetStage(0x035B5A) == 10.0")
    }
    
    func testGetIsAliasRef() {
        let expression = Expression(function: 566, value: 1065353216, comparison: .equals, flags: [], parameters: [1, 0], runOn: .subject)
        XCTAssertEqual(expression.rawValue, "Subject.GetIsAliasRef(0x1) == 1.0")
    }
     
    func testIsScenePlaying() {
        let expression = Expression(function: 248, value: 0, comparison: .equals, flags: [], parameters: [220000, 0], runOn: .subject)
        XCTAssertEqual(expression.rawValue, "Subject.IsScenePlaying(0x035B60) == 0.0")
    }
    
    func testGetBribeSuccess() {
        let expression = Expression(function: 654, value: 1065353216, comparison: .equals, flags: [], parameters: [0, 0], runOn: .subject)
        XCTAssertEqual(expression.rawValue, "Subject.GetBribeSuccess() == 1.0")
    }
    
    func testGetActorValue() {
        let expression = Expression(function: 14, value: 857763, comparison: .greaterThanOrEqual, flags: [.useGlobal], parameters: [17, 0], runOn: .subject)
        XCTAssertEqual(expression.rawValue, "Subject.GetActorValue(17) >= Global(0x0D16A3)")
    }
}

