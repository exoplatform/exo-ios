//
//  UrlTest.swift
//  eXoTests
//
//  Created by Frédéric DROUET on 27/09/2018.
//  Copyright © 2018 eXo. All rights reserved.
//

import XCTest
@testable import eXo

class ToolTest: eXoBaseTestCase {

    func testExtractServerUrl() {
        
        let httpUrl = "http://my.vhost.org"
        let httpsUrl = "https://my.vhost.org"

        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "my.vhost.org"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "my.vhost.org:80"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "my.vhost.org:443"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://my.vhost.org"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://my.vhost.org/"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://my.vhost.org/my/param"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://my.vhost.org/my/param?"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://my.vhost.org/my/param?a=b"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://my.vhost.org:80/"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://my.vhost.org:8080/"), "http://my.vhost.org:8080")
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://user@my.vhost.org"), httpUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "http://user:password@my.vhost.org"), httpUrl)

        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "https://my.vhost.org"), httpsUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "https://my.vhost.org/"), httpsUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "https://my.vhost.org/my/param"), httpsUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "https://my.vhost.org/my/param?"), httpsUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "https://my.vhost.org/my/param?a=b"), httpsUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "https://my.vhost.org:443/"), httpsUrl)
        XCTAssertEqual(Tool.extractServerUrl(sourceUrl: "https://my.vhost.org:8443/"), "https://my.vhost.org:8443")
    }
}
