//
//  TestServerSelectScreen.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 12/31/15.
//  Copyright © 2015 eXo. All rights reserved.
//
import XCTest
@testable import eXo

class TestServerSelectScreen: eXoUIBaseTestCase {

    // langue english

    /**
    func testNumberOfButton() {
        let app = XCUIApplication()
        XCTAssertEqual(app.buttons.count, 4)
    }
 */
/**
    func testOpenSetting () {
        let app = XCUIApplication()
        XCTAssertEqual(app.buttons.count, 4)
        // tap the 3 dots button
        app.buttons.elementBoundByIndex(0).tap()
        XCTAssertEqual(app.tables.count,1)
        XCTAssert(app.navigationBars["Settings"].exists)
    }

    func testOpenDefaultServer () {
        let app = XCUIApplication()
        XCTAssertEqual(app.buttons.count, 4)
        app.buttons["button.discover.tribe"].tap()
        _ = self.expectationForPredicate(
            NSPredicate(format: "count == 1"),
            evaluatedWithObject: app.webViews,
            handler: nil)
        self.waitForExpectationsWithTimeout(100.0) { (error) -> Void in
            if error != nil {
                XCTFail("Expect webview to be shown")
            }
        }
    
    }

    func testOpenAddServer () {
        let app = XCUIApplication()
        XCTAssertEqual(app.buttons.count, 4)
        app.buttons["button.new.server"].tap()
        XCTAssertEqual(app.textViews.count,1)
        XCTAssertEqual(app.tables.count,1)
    }
    
    */

}
