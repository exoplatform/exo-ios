//
//  TestAddServer.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 12/14/15.
//  Copyright © 2015 eXo. All rights reserved.
//

import XCTest

class TestAddServer: eXoUIBaseTestCase {
    
    func testAddServer()  {
        
        let app = XCUIApplication()
        
        //--- Add new server button
        app.buttons["button.new.server"].tap()
        
        //--- Server URL area
        let serverNameText = app.staticTexts["Enter your intranet URL"]
        XCTAssert(serverNameText.exists)
        
        //--- Add server URL
        serverNameText.tap()
        app.typeText("https://community.exoplatform.com\n")
        
/**
        self.expectationForPredicate(NSPredicate(format: "count == 0"), evaluatedWithObject: app.webViews, handler: nil)
        
        
        self.waitForExpectationsWithTimeout(100.0) { (error) -> Void in
            if error != nil {
                 XCTFail("Expect webview to be shown")
            }
        }
 */
        
    }
    
    func testAddServerNotSupport() {
        
        let app = XCUIApplication()
        app.buttons["button.new.server"].tap()
        
        //--- Server URL area
        let serverNameText = app.textViews.staticTexts["Enter your intranet URL"]
        XCTAssert(serverNameText.exists)
        
        // TODO: add a request interceptor to avoid hitting the real server, and return a predefined response
        //--- Add server URL
        serverNameText.tap()
        app.typeText("https://exoplatform.exoplatform.net\n")
        let alert = app.alerts.elementBoundByIndex(0)
        self.expectationForPredicate(NSPredicate (format: "exists == 1", argumentArray: nil), evaluatedWithObject: alert, handler: nil)
        self.waitForExpectationsWithTimeout(100.0) { (error) -> Void in
            if error == nil {
                XCTAssertEqual(alert.label, "Intranet URL error")
                let okButton = alert.buttons["OK"]
                okButton.tap()
            } else {
                XCTFail("Expect alertview to be shown")
            }
        }
    
    }
    
    func testAddServerInvalidURL() {
        
        let app = XCUIApplication()
        app.buttons["button.new.server"].tap()

        //--- Need focus on the element
        app.textViews.staticTexts["Enter your intranet URL"].tap()
        //--- Add server URL
        app.typeText("http://invalid_server\n")
        //--- Get alert popup component
        let alert = app.alerts.elementBoundByIndex(0)
        //--- Check content of popup
        self.expectationForPredicate(NSPredicate (format: "exists == 1", argumentArray: nil), evaluatedWithObject: alert, handler: nil)
        self.waitForExpectationsWithTimeout(100.0) { (error) -> Void in
            if error == nil {
                XCTAssertEqual(alert.label, "Intranet URL error")
                let okButton = alert.buttons["OK"]
                okButton.tap()
            } else {
                XCTFail("Expect alertview to be shown")
            }
        }

    }
}
