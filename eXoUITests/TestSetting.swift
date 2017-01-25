//
//  TestSetting.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 12/14/15.
//  Copyright © 2015 eXo. All rights reserved.
//

import XCTest
@testable import eXo

/*
This Test should be run after the TestAddServer
*/
class TestSetting: eXoUIBaseTestCase {
        
    func gotoSettingScreen () {
        let app = XCUIApplication()
        app.buttons.elementBoundByIndex(0).tap()
        //XCTAssertEqual(app.tables.count, 0)
    }
    
    func testOpenSetting() {
        self.gotoSettingScreen()
    }
    /**
    func testEditServerError() {

        self.gotoSettingScreen()
        let app = XCUIApplication()

        if app.tables.cells.count > 0 {
            app.tables.cells.elementBoundByIndex(0).tap()
            if (app.textViews.count > 0) {
                app.textViews.elementBoundByIndex(0).tap()
                app.typeText("invalide\n")
                let alert = app.alerts.elementBoundByIndex(0)
                let existePredicate = NSPredicate (format: "exists == 1", argumentArray: nil)
                self.expectationForPredicate(existePredicate, evaluatedWithObject: alert, handler: nil)
                self.waitForExpectationsWithTimeout(100.0) { (error) -> Void in
                    if error == nil {
                        XCTAssertEqual(alert.label, "Intranet URL error")
                        let okButton = alert.buttons["OK"]
                        XCTAssertNotNil(okButton)
                        okButton.tap()
                    } else {
                        XCTFail("Expect alertview to be shown")
                    }
                }
            }
        }
    }
 */
    
    func testEditServer() {
        self.gotoSettingScreen()
        let app = XCUIApplication()
        
        if app.tables.cells.count > 0 {
            app.tables.cells.elementBoundByIndex(0).tap()
            if (app.textViews.count > 0) {
                app.textViews.elementBoundByIndex(0).tap()
                app.typeText("\n")
            }
        }
    }

    
    /**
    func testDeleteFirstServer () {
        self.gotoSettingScreen()
        let app = XCUIApplication()
        
        let tablesQuery = app.tables
        let nb_server = tablesQuery.cells.count
        if app.tables.cells.count > 0 {
            let cell = tablesQuery.cells.elementBoundByIndex(0)
            cell.swipeLeft()
            if (app.textViews.count > 0) {
                app.tables.buttons["Delete"].tap()
                XCTAssertNotNil(app.alerts["Delete Server"])
                app.alerts["Delete Server"].collectionViews.buttons["OK"].tap()
                XCTAssertEqual(nb_server-1, tablesQuery.cells.count)
            }
        }
        
    }
 */
    
}
