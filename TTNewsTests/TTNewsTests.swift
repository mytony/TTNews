//
//  TTNewsTests.swift
//  TTNewsTests
//
//  Created by Meng-Yu Chung on 1/17/22.
//

import XCTest
@testable import TTNews

class TTNewsTests: XCTestCase {

    // MARK: Extensions
    
    func testCaptilizingFirstLetter() {
        let target = "hello"
        XCTAssertEqual(target.capitalizingFirstLetter(), "Hello")
    }
    
    // MARK: SelectionButtonsView
    
    func testGetSelection() {
        let view = SelectionButtonsView(frame: .zero)
        let options = ["general", "business"]
        
        // Empty state
        var selection = view.getSelection()
        var expected = [String]()
        XCTAssertEqual(selection, expected)
        
        // Add two buttons
        view.configureSelectionOptions(titles: options)
        XCTAssertEqual(view.buttons.count, 2)
        
        selection = view.getSelection()
        expected = options
        XCTAssertEqual(selection, expected)
        
        // Disable "general"
        view.buttons[0].sendActions(for: .touchUpInside)
        selection = view.getSelection()
        expected = ["business"]
        XCTAssertEqual(selection, expected)
    }
}
