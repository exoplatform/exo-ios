//
//  TestCookiesFromAuthorizationFetcher.swift
//  eXoTests
//
//  Created by Paweł Walczak on 07.02.2018.
//  Copyright © 2018 eXo. All rights reserved.
//

import XCTest
@testable import eXo

class TestCookiesFromAuthorizationFetcher: XCTestCase {
    
    let fetcher = CookiesFromAuthorizationFetcher()
    
    func test_whenNilHeaderValue_thenResultDictionaryShouldBeEmpty() {
        // given
        let headerValue: String? = nil
        
        // when
        let result = fetcher.fetch(headerValue: headerValue)
        
        // then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_whenCookiesInHeaders_thenDictionaryShouldContainCorrectData() {
        // given
        let headerValue: String? = "key1=value1;key2=value2;"
        
        // when
        let result = fetcher.fetch(headerValue: headerValue)
        
        // then
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(2, result.count)
        XCTAssertEqual("value1", result["key1"])
        XCTAssertEqual("value2", result["key2"])
    }
    
    func test_whenCookiesInHeaders_thenArrayShouldContainCorrectHTTPCookieObjects() {
        // given
        let headerValue: String? = "key1=value1;key2=value2;"
        let urlString = "http://www.example.com"
        let url = URL(string: urlString)!
        
        // when
        let result = fetcher.fetch(headerValue: headerValue, url: url)
        
        // then
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(2, result.count)
        
        XCTAssertNotNil(result.first(where: { $0.name == "key1" && $0.value == "value1" && $0.domain == urlString }))
        XCTAssertNotNil(result.first(where: { $0.name == "key2" && $0.value == "value2" && $0.domain == urlString }))
    }
}
