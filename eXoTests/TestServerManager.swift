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
        ServerKey.serverURL:      "https://test.exoplatform.com",
        ServerKey.username:       "john",
        ServerKey.lastConnection: NSDate().timeIntervalSince1970
    ]
    
    let server:Server = Server(serverDictionary: TestServerManager.serverValues)
    
    let manager:ServerManager = ServerManager.sharedInstance
    
    override func setUp() {
        super.setUp()
        removeAllServers()
    }
    
    override func tearDown() {
        removeAllServers()
        super.tearDown()
    }
    
    func removeAllServers() {
        for server in manager.serverList {
            manager.removeServer(server as! Server)
        }
    }
    
    func testInitServerManager() {
        XCTAssertNotNil(manager.serverList, "Server List must not be nil")
    }
    
    func testAddDeleteServer() {
        manager.addEditServer(server)
        XCTAssertEqual(manager.serverList.count, 1, "Server List should contain 1 server")
        manager.removeServer(server)
        XCTAssertEqual(manager.serverList.count, 0, "Server List should be empty")
    }
    
    func testServerExists() {
        manager.addEditServer(server)
        XCTAssertTrue(manager.isExist(server), "Server should exist")
        manager.removeServer(server)
        XCTAssertFalse(manager.isExist(server), "Server should not exist")
    }
    
//    func testParseServer() {
//        let attributes:[String : String] = {[
//            "serverURL" : "https://test.exoplatform.com" ,
//            "username"  : "john"
//        ]}()
//        let parser:ServerManager.ServersXmlParser = ServerManager.ServersXmlParser()
//        let server:Server = parser.parseServer(attributes)
//        XCTAssertEqual(server.serverURL, "https://test.exoplatform.com")
//        XCTAssertEqual(server.username, "john")
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
