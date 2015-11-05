//
//  TestServerManager.swift
//  eXo
//
//  Created by exoplatform on 11/5/15.
//  Copyright © 2015 eXo. All rights reserved.
//
// Copyright (C) 2003-2015 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.


import XCTest
@testable import eXo

class TestServerManager: eXoBaseTestCase {
    
    static let serverValues:NSDictionary = [
        ServerKey.serverURL:      "https://community.exoplatform.com",
        ServerKey.username:       "john",
        ServerKey.lastConnection: NSDate().timeIntervalSince1970
    ]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitServerManager() {
//        let mgr:ServerManager = ServerManager.sharedInstance
//        mgr.userDefaults = NSUserDefaults.mockDefaults()
//        XCTAssertNotNil(mgr.serverList, "Server List must not be nil")
//        XCTAssertEqual(NSMutableArray(), mgr.serverList, "Server List is not initiated as NSMutableArray")
    }
    
    func testAddServer() {
//        let defaults:NSUserDefaults = NSUserDefaults.mockDefaults()
//        let server:Server = Server(serverDictionary: TestServerManager.serverValues)
//        let mgr:ServerManager = ServerManager.sharedInstance
//        mgr.userDefaults = defaults
//        mgr.addServer(server)
//        let serverList:NSMutableArray = defaults.objectForKey(UserDefaultConfig.listServerKey) as! NSMutableArray
//        XCTAssertEqual(mgr.serverList.count, 1, "Server List should contain 1 server")
//        XCTAssertEqual(serverList.count, 1, "Server List should contain 1 server")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
