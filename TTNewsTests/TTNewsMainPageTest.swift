//
//  TTNewsMainPageTest.swift
//  TTNewsTests
//
//  Created by Meng-Yu Chung on 1/20/22.
//

import XCTest
@testable import TTNews

class TTNewsMainPageTest: XCTestCase {
    
    var sut: NewsViewController!

    override func setUpWithError() throws {
        sut = NewsViewController()
        sut.loadViewIfNeeded()
        print(sut.currentPage)
        print(sut.currentCategory)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testNotification() {
        
    }

}
