//
//  TTNewsUITests.swift
//  TTNewsUITests
//
//  Created by Meng-Yu Chung on 1/20/22.
//

import XCTest
@testable import TTNews

class TTNewsUITests: XCTestCase {
    
    var app: XCUIApplication!
    let categories: [String] = ["General", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"]

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    func testComponentsExistInNewsPage() throws {
        let scrollViewElements = app.scrollViews.otherElements
        
        for category in categories {
            XCTAssertTrue(scrollViewElements.buttons[category].exists)
        }
        
        XCTAssertTrue(app.collectionViews.element.exists)
    }
    
    
    // Disable all categories but the last one won't be allowed to disable
    func testDisableAllCateogryAttempt() throws {
        app.tabBars["Tab Bar"].buttons["Settings"].tap()

        for category in categories {
            app.buttons[category].tap()
        }

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
