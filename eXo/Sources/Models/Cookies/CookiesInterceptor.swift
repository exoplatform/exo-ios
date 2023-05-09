//
//  CookiesInterceptor.swift
//  eXo
//
//  Created by Paweł Walczak on 29.01.2018.
//  Copyright © 2018 eXo. All rights reserved.
//

import Foundation

protocol CookiesInterceptor {
    func intercept(_ cookies: [HTTPCookie], url: URL)
}

class CookiesInterceptorFactory {
    func create() -> CookiesInterceptor {
        return CookiesInterceptorProxy(interceptors: [SessionCookieInterceptor(), RememberMeCookieInterceptor() ])
    }
}

fileprivate class CookiesInterceptorProxy: CookiesInterceptor {
    
    private let interceptors: [CookiesInterceptor]
    
    init(interceptors: [CookiesInterceptor]) {
        self.interceptors = interceptors
    }
    
    func intercept(_ cookies: [HTTPCookie], url: URL) {
        interceptors.forEach { $0.intercept(cookies, url: url) }
    }
}

fileprivate class SessionCookieInterceptor: CookiesInterceptor {
    func intercept(_ cookies: [HTTPCookie], url: URL) {
        if let session = cookies.first(where: { $0.name == Cookies.session.rawValue })?.value {
            PushTokenRestClient.shared.sessionCookieValue = session
        }
        
        if let sessionSso = cookies.first(where: { $0.name == Cookies.sessionSso.rawValue })?.value {
            PushTokenRestClient.shared.sessionSsoCookieValue = sessionSso
        }
    }
}

fileprivate class RememberMeCookieInterceptor: CookiesInterceptor {
    func intercept(_ cookies: [HTTPCookie], url: URL) {
        guard let rememberMe = cookies.first(where: { $0.name == Cookies.rememberMe.rawValue })?.value else { return }
        PushTokenRestClient.shared.rememberMeCookieValue = rememberMe
    }
}
