//
//  eXoSnapshots.swift
//  eXoSnapshots
//
//  Created by exoplatform on 1/28/16.
//  Copyright © 2016 eXo. All rights reserved.
//

import XCTest

class eXoSnapshots: XCTestCase {
    
    /*
     * MARK:    Initialization
     */
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    // Executed first, to delete all existing servers
    func test_00a_Init_Delete_All_Servers() {

        let app = XCUIApplication()
        app.buttons["more"].tap()
        while (app.tables.cells.elementBoundByIndex(0).exists) {
            app.tables.cells.elementBoundByIndex(0).tap()
            if (app.buttons["Delete"].exists) {
                app.buttons["Delete"].tap()
                app.alerts["Delete intranet"].collectionViews.buttons["OK"].tap()
            } else {
                break
            }
        }
    }
    
    // Executed second, to add the eXo Tribe server
    func test_00b_Init_Add_Tribe_Server() {
        
        XCUIApplication().buttons["button.discover.tribe"].tap()
        
    }
    
    /*
     * MARK:    Snapshots methods
     */
    
    func test_01_Snap_Launch_Screen() {
        
        snapshot("01_Launch_Screen")
    }
    
    func test_02_Snap_New_Server_Screen() {
    
        XCUIApplication().buttons["button.new.server"].tap()
        snapshot("02_New_Server_Screen")
    }
    
    func test_03_Snap_Settings_Home_Screen() {
        
        XCUIApplication().buttons["more"].tap()
        snapshot("03_Settings_Home_Screen")
    }
    
    func test_04_Snap_Edit_Server_Screen() {
        
        let app = XCUIApplication()
        app.buttons["more"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["community.exoplatform.com"].tap()
        snapshot("04_Edit_Server_Screen")
    }
    
    func test_05_Snap_WebView_Home_Screen() {
        // Start the app and launch the demo intranet based on PLF 4.3.0
        let app = XCUIApplication()
        app.buttons["button.new.server"].tap()
        let tablesQuery = app.tables
        tablesQuery.textViews.containingType(.StaticText, identifier:"Enter your intranet URL").element.tap()
        tablesQuery.textViews.staticTexts["Enter your intranet URL"].tap()
//        app.typeText("plfent-4.3.0.acceptance6.exoplatform.org\n")
        app.typeText("http://plfent-4.3.x-snapshot.acceptance6.exoplatform.org\n")
        // Skip all registration pages
        var canSignIn = false
        repeat {
            self.expectationForPredicate(
                // we expect the button "Sign In" to exist on the page
                NSPredicate(format: "exists == 1"),
                evaluatedWithObject: app.buttons["Sign In"],
                handler: nil)
            self.waitForExpectationsWithTimeout(10) { (error) -> Void in
                if error != nil {
                    // there's an error => the "Sign In" button does not exist
                    // we are probably on a registration page => skip it
                    if app.buttons["Skip"].exists {
                        app.buttons["Skip"].tap()
                    } else {
                        XCTFail("Unexpected state: neither Sign In nor Skip button exists")
                    }
                } else {
                    // no error => the "Sign In" button exists => we can sign in
                    canSignIn = true
                }
            }
        }
        // repeat until we detected the "Sign In" button on the current page
        while (!canSignIn)
        
//        let navbars = app.navigationBars.count
        
        // Just making sure...
        XCTAssertTrue(app.textFields["Username"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        
        // Filling in the login form
        app.textFields["Username"].tap()
        app.typeText("root")
        app.secureTextFields["Password"].tap()
        app.typeText("gtn")
        app.buttons["Sign In"].tap()
        self.expectationForPredicate(
            NSPredicate(format: "exists == 1"),
            evaluatedWithObject: app.otherElements["Home Page"],
            handler: nil)
        self.waitForExpectationsWithTimeout(30, handler: nil)
        
        snapshot("05_Platform_Home_Page")
    }
    
}
