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
    
//    func test02SnapTribeHome() {
//        
//        XCUIApplication().buttons["button.discover.tribe"].tap()
//        snapshot("2platformHome")
//    }
    
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
    
}
