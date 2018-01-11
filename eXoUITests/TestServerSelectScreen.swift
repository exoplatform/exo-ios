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

    
    func testNumberOfButton() {
        let app = XCUIApplication()
        XCTAssertEqual(app.buttons.count, 4)
    }
 

    //--- crachs randomly
    func testOpenSetting () {

        let app = XCUIApplication()
        app.buttons["more"].tap()
        let settingsNavigationBar = app.navigationBars["Settings"]
        XCTAssert(settingsNavigationBar.exists)
        XCTAssert(app.staticTexts["About"].exists)
        
        
    }

    
    
    func testOpenDefaultServer () {
        let app = XCUIApplication()
        XCTAssertEqual(app.buttons.count, 4)
        app.buttons["button.discover.tribe"].tap()
       
        //--- Asynchrone test : test if Community web page exists
        let webViewQury:XCUIElementQuery = app.descendantsMatchingType(.WebView)
        let webView = webViewQury.elementBoundByIndex(0)
        
        //--- Check if you condition is valide after 15sec
        self.expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: webView, handler: nil)
        self.waitForExpectationsWithTimeout(15.0, handler: nil)
        
    }
    
    
    func testOpenAddServer () {
        let app = XCUIApplication()
        XCTAssertEqual(app.buttons.count, 4)
        app.buttons["button.new.server"].tap()
        XCTAssertEqual(app.textViews.count,0)
        XCTAssertEqual(app.tables.count,0)
    }

}
