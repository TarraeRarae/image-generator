//
//  MainButtonTableViewCellUITests.swift
//  image-generatorUITests
//
//  Created by Alexey Zubkov on 31.05.2023.
//

import XCTest

final class MainButtonTableViewCellUITests: XCTestCase {

    // MARK: Dependencies

    var app: XCUIApplication!

    // MARK: Lifecycle

    override func setUp() {
        super.setUp()
        continueAfterFailure = true

        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil

        super.tearDown()
    }
}

// MARK: - Tests

extension MainButtonTableViewCellUITests {

    func testClearTextFieldButtonTap() {
        app.tables/*@START_MENU_TOKEN@*/.buttons["Generate image"]/*[[".cells.buttons[\"Generate image\"]",".buttons[\"Generate image\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Unable to generate image"].scrollViews.otherElements.buttons["OK"].tap()
    }

    func testFilledTextButtonTap() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.textFields.firstMatch.tap()
        tablesQuery.textFields.firstMatch.typeText("Example")
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Generate image"]/*[[".cells.buttons[\"Generate image\"]",".buttons[\"Generate image\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["https://dummyimage.com/350x350&text=Example"]/*[[".cells.staticTexts[\"https:\/\/dummyimage.com\/350x350&text=Example\"]",".staticTexts[\"https:\/\/dummyimage.com\/350x350&text=Example\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.swipeUp()
    }
}
