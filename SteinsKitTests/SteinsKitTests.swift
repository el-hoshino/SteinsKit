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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
