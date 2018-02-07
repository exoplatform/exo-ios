//
//  CookiesFromAuthorizationFetcher.swift
//  eXo
//
//  Created by Paweł Walczak on 07.02.2018.
//  Copyright © 2018 eXo. All rights reserved.
//

import Foundation

class CookiesFromAuthorizationFetcher {
    
    func fetch(headerValue: String?) -> [String: String] {
        guard let headerValue = headerValue else { return [:] }
        var result = [String: String]()
        let cookies = headerValue.split(separator: ";")
        for c in cookies {
            let keyValue = c.split(separator: "=")
            guard keyValue.count == 2 else { continue }
            let key = String(keyValue[0])
            let value = String(keyValue[1])
            guard !key.withoutWhitespaces.isEmpty, !value.withoutWhitespaces.isEmpty else { continue }
            result[key.withoutWhitespaces] = value.withoutWhitespaces
        }
        return result
    }
    
    func fetch(headerValue: String?, url: URL) -> [HTTPCookie] {
        let cookies = self.fetch(headerValue: headerValue)
        guard !cookies.isEmpty else { return [] }
        var result = [HTTPCookie]()
        for c in cookies {
            guard let cookie = fromKeyValueToCookie(cookie: c, url: url) else { continue }
            result.append(cookie)
        }
        return result
    }
    
    private func fromKeyValueToCookie(cookie: (key: String, value: String), url: URL) -> HTTPCookie? {
        return HTTPCookie(properties: [
                HTTPCookiePropertyKey.name: cookie.key,
                HTTPCookiePropertyKey.value: cookie.value,
                HTTPCookiePropertyKey.domain: url.absoluteString.serverDomainWithProtocolAndPort ?? "",
                HTTPCookiePropertyKey.originURL: url,
                HTTPCookiePropertyKey.path: "/",
                HTTPCookiePropertyKey.secure: true
            ]
        )
    }
}

extension String {
    var withoutWhitespaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
