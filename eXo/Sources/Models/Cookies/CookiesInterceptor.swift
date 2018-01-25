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
        return CookiesInterceptorProxy(interceptors: [SessionCookieInterceptor(), RememberMeCookieInterceptor(), UsernameCookieInterceptor()])
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
        PushTokenRestClient.shared.sessionCookieValue = cookies.first(where: { $0.name == Cookies.session.rawValue })?.value
        PushTokenRestClient.shared.sessionSsoCookieValue = cookies.first(where: { $0.name == Cookies.sessionSso.rawValue })?.value
    }
}

fileprivate class RememberMeCookieInterceptor: CookiesInterceptor {
    func intercept(_ cookies: [HTTPCookie], url: URL) {
        PushTokenRestClient.shared.rememberMeCookieValue = cookies.first(where: { $0.name == Cookies.rememberMe.rawValue })?.value
    }
}

fileprivate class UsernameCookieInterceptor: CookiesInterceptor {
    func intercept(_ cookies: [HTTPCookie], url: URL) {
        if let usernameCookie = cookies.first(where: { $0.name == Cookies.username.rawValue}) {
            PushTokenSynchronizer.shared.username = usernameCookie.value
            PushTokenSynchronizer.shared.url = url.absoluteString.serverDomainWithProtocolAndPort
        }
    }
}
