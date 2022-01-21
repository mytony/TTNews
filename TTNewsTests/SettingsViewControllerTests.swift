//
//  TTNewsMainPageTest.swift
//  TTNewsTests
//
//  Created by Meng-Yu Chung on 1/20/22.
//

import XCTest
@testable import TTNews

class SettingsViewControllerTests: XCTestCase {
    
    var sut: SettingsViewController!

    override func setUpWithError() throws {
        sut = SettingsViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testPostNotification() {
        let _ = expectation(forNotification: NotificationNames.categorySettingChanged, object: nil) { notification in
            guard let extraInfo = notification.userInfo else { return false }
            XCTAssertNotNil(extraInfo[Settings.categories] as? [String])
            guard let categories = extraInfo[Settings.categories] as? [String] else { return false }
            XCTAssertEqual(categories[0], "general")
            XCTAssertEqual(categories.count, Category.allCases.count)
            return true
        }
        sut.viewWillDisappear(false)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

}
