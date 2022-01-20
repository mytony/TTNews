//
//  TTNewsUITests.swift
//  TTNewsUITests
//
//  Created by Meng-Yu Chung on 1/20/22.
//

import XCTest

class TTNewsUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    func testComponentsExistInNewsPage() throws {
        let scrollViewElements = app.scrollViews.otherElements
        XCTAssertTrue(scrollViewElements.buttons["General"].exists)
        XCTAssertTrue(scrollViewElements.buttons["Business"].exists)
        XCTAssertTrue(scrollViewElements.buttons["Entertainment"].exists)
        XCTAssertTrue(scrollViewElements.buttons["Health"].exists)
        XCTAssertTrue(scrollViewElements.buttons["Science"].exists)
        XCTAssertTrue(scrollViewElements.buttons["Sports"].exists)
        XCTAssertTrue(scrollViewElements.buttons["Technology"].exists)
        
        XCTAssertTrue(app.collectionViews.element.exists)
    }
    
    
    // Disable all categories but the last one won't be allowed to disable
    func testDisableAllCateogryAttempt() throws {
        app.tabBars["Tab Bar"].buttons["Settings"].tap()

        app.buttons["General"].tap()
        app.buttons["Business"].tap()
        app.buttons["Entertainment"].tap()
        app.buttons["Health"].tap()
        app.buttons["Science"].tap()
        app.buttons["Sports"].tap()
        app.buttons["Technology"].tap()

        app.tabBars["Tab Bar"].buttons["News"].tap()

        XCTAssertFalse(app.buttons["General"].exists)
        XCTAssertFalse(app.buttons["Business"].exists)
        XCTAssertFalse(app.buttons["Entertainment"].exists)
        XCTAssertFalse(app.buttons["Health"].exists)
        XCTAssertFalse(app.buttons["Science"].exists)
        XCTAssertFalse(app.buttons["Sports"].exists)
        XCTAssertTrue(app.buttons["Technology"].exists)
    }
}
