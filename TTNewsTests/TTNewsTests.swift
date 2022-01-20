//
//  TTNewsTests.swift
//  TTNewsTests
//
//  Created by Meng-Yu Chung on 1/17/22.
//

import XCTest
@testable import TTNews

class TTNewsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFirstLetterCapitalized() {
        let target = "hello"
        XCTAssertEqual(target.capitalizingFirstLetter(), "Hello")
    }
}
