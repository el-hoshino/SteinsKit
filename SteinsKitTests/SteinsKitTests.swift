//
//  SteinsKitTests.swift
//  SteinsKitTests
//
//  Created by 史 翔新 on 2019/03/21.
//  Copyright © 2019 Crazism. All rights reserved.
//

import XCTest
@testable import SteinsKit

class SteinsKitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormalObservation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let int = Variable(0)
        let label = UILabel()
        
        XCTAssert(label.text == nil)
        
        int.asAnyObservable()
            .map({ $0 * 2 })
            .map({ "\($0)" })
            .beObserved(by: label, onChanged: { $0.text = $1 })
        XCTAssert(label.text == "0")
        
        int.accept(1)
        XCTAssert(label.text == "2")
        
        var checked = false
        int.runWithLatestValue({ XCTAssert($0 == 1); checked = true })
        XCTAssert(checked)
        
    }
    
    func testRunWithLatestValue() {
        
        let int = Variable(0)
        
        var checked = false
        int.runWithLatestValue({ XCTAssert($0 == 0); checked = true })
        XCTAssert(checked)
        
        checked = false
        XCTAssert(!checked)
        
        int.accept(1)
        int.runWithLatestValue({ XCTAssert($0 == 1); checked = true })
        XCTAssert(checked)
        
    }
    
    func testExistance() {
        
        let int = Variable(0)
        let intMirror = Mirror(reflecting: int)
        
        var label: UILabel? = UILabel()
        int.map({ "\($0)" }).beObserved(by: label!, onChanged: { $0.text = $1 })
        XCTAssert(intMirror.observations.count == 1)
        
        label = nil
        int.accept({ $0 })
        int.accept({ $0 })
        // ↑ to run observation cycles so unneeded observations can be released
        // since int has a map, it has to execute 2 `accept`s to release the objects:
        // on the 1st time, the mapped variable's observations will become empty because label released
        // then on the 2nd time, int's observations will becom empty because the mapped variable has no observations
        XCTAssert(intMirror.observations.count == 0)
        
        var disposer: NSObject? = NSObject()
        
        label = UILabel()
        XCTAssert(label?.text == nil)
        
        int.beObserved(by: label!, disposer: disposer, onChanged: { $0.text = "\($1)" })
        XCTAssertEqual(intMirror.observations.count, 1)
        XCTAssertEqual(label?.text, "0")
        
        disposer = nil
        int.accept(1)
        XCTAssertEqual(intMirror.observations.count, 0)
        XCTAssertEqual(label?.text, "0")
        
        label = UILabel()
        XCTAssertEqual(label?.text, nil)
        
        int.beObserved(by: label!, disposer: disposer, onChanged: { $0.text = "\($1)" })
        XCTAssertEqual(intMirror.observations.count, 0)
        XCTAssertEqual(label?.text, nil)
        
        int.accept(2)
        XCTAssertEqual(label?.text, nil)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

private extension Mirror {
    
    var observations: Set<Observation<Int>> {
        return value(of: "observations", as: Set<Observation<Int>>.self)
    }
    
    func value <Value> (of name: String, `as` type: Value.Type) -> Value {
        
        let child = children.first(where: { $0.label == name })!
        // swiftlint:disable:next force_cast
        return child.value as! Value
    }
    
}
