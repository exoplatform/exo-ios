//
//  TestServer.swift
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

class TestServer: eXoBaseTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitServerWithEmptyValues() {
        let server:Server = Server()
        XCTAssertEqual(server.serverURL, "", "Server URL should be empty");
        XCTAssertEqual(server.username, "", "Username should be empty");
        XCTAssertEqual(server.lastConnection, 0, "Last Connection should be 0");
    }
    
    func testInitWithServerURL() {
        let url:String = "https://community.exoplatform.com"
        let server:Server = Server(serverURL: url)
        XCTAssertEqual(server.serverURL, url, "Server URL did not match");
        XCTAssertNotEqual(server.lastConnection, 0, "Last Connection should not be 0");
    }
    
    func testInitServerWithValues() {
        let now:Double = NSDate().timeIntervalSince1970
        let url:String = "https://community.exoplatform.com"
        let user:String = "john"
        let server:Server = Server(serverURL: url, username: user, lastConnection: now)
        XCTAssertEqual(server.serverURL, url, "Server URL did not match");
        XCTAssertEqual(server.username, user, "Username did not match");
        XCTAssertEqual(server.lastConnection, now, "Last Connection did not match");
    }
    
    func testInitServerWithDictionary() {
        let now:Double = NSDate().timeIntervalSince1970
        let url:String = "https://community.exoplatform.com"
        let user:String = "john"
        let values:NSDictionary = [
            ServerKey.serverURL:      url,
            ServerKey.username:       user,
            ServerKey.lastConnection: now
        ]
        let server:Server = Server(serverDictionary: values)
        XCTAssertEqual(server.serverURL, url, "Server URL did not match")
        XCTAssertEqual(server.username, user, "Username did not match")
        XCTAssertEqual(server.lastConnection, now, "Last Connection did not match")
    }
    
    func testServerToDictionary() {
        let now:Double = NSDate().timeIntervalSince1970
        let url:String = "https://community.exoplatform.com"
        let user:String = "john"
        let server:Server = Server(serverURL: url, username: user, lastConnection: now)
        let values:NSDictionary = server.toDictionary()
        XCTAssertEqual(values.valueForKey(ServerKey.serverURL) as? String, url, "Server URL did not match")
        XCTAssertEqual(values.valueForKey(ServerKey.username) as? String, user, "Username did not match")
        XCTAssertEqual(values.valueForKey(ServerKey.lastConnection) as? Double, now, "Last connection did not match")
    }
    
    func testServerNaturalNameWithShortURL() {
        let now:Double = NSDate().timeIntervalSince1970
        let url:String = "https://int.company.com"
        let shortUrl:String = "int.company.com"
        let user:String = "john"
        let server:Server = Server(serverURL: url, username: user, lastConnection: now)
        XCTAssertEqual(server.natureName(), shortUrl, "Short URL did not match")
    }
    
    func testServerNaturalNameWithLongURL() {
        let now:Double = NSDate().timeIntervalSince1970
        let url:String = "https://secure.community.exoplatform.com"
        let shortUrl:String = "secure.c...exoplatform.com"
        let user:String = "john"
        let server:Server = Server(serverURL: url, username: user, lastConnection: now)
        XCTAssertEqual(server.natureName(), shortUrl, "Short URL did not match")
    }
    
    func testServerAlreadyExists() {
        
        var serverBase:Server = Server(serverURL: "http://server.com")
        // the exact same url
        let server1:Server = Server(serverURL: "http://server.com")
        // protocol is ignored in the comparison
        let server2:Server = Server(serverURL: "https://server.com")
        // path is ignored
        let server3:Server = Server(serverURL: "http://server.com/portal")
        // port is ignored
        let server4:Server = Server(serverURL: "http://server.com:80")
        // font case is ignored
        let server5:Server = Server(serverURL: "HTTP://SERVER.COM")
        
        XCTAssertTrue(serverBase.isEqual(server1), String(format: "Server %@ should be equal to server base %@", server1.serverURL, serverBase.serverURL))
        XCTAssertTrue(serverBase.isEqual(server2), String(format: "Server %@ should be equal to server base %@", server2.serverURL, serverBase.serverURL))
        XCTAssertTrue(serverBase.isEqual(server3), String(format: "Server %@ should be equal to server base %@", server3.serverURL, serverBase.serverURL))
        XCTAssertTrue(serverBase.isEqual(server4), String(format: "Server %@ should be equal to server base %@", server4.serverURL, serverBase.serverURL))
        XCTAssertTrue(serverBase.isEqual(server5), String(format: "Server %@ should be equal to server base %@", server5.serverURL, serverBase.serverURL))
        
        serverBase = Server(serverURL: "http://server.com:80")
        // port is ignored
        let server6:Server = Server(serverURL: "http://server.com:8080")
        
        XCTAssertTrue(serverBase.isEqual(server6), String(format: "Server %@ should be equal to server base %@", server6.serverURL, serverBase.serverURL))
    }
    
    func testServerDoesNotExist() {
        
        let serverBase:Server = Server(serverURL: "http://server.com")
        
        let server1:Server = Server(serverURL: "http://my.server.com")
        let server2:Server = Server(serverURL: "http://server.fr")
        
        XCTAssertFalse(serverBase.isEqual(server1), String(format: "Server %@ should be different than server base %@", server1.serverURL, serverBase.serverURL))
        XCTAssertFalse(serverBase.isEqual(server2), String(format: "Server %@ should be different than server base %@", server2.serverURL, serverBase.serverURL))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
