//
//  PushTokenRestClient.swift
//  eXo
//
//  Created by Paweł Walczak on 29.01.2018.
//  Copyright © 2018 eXo. All rights reserved.
//

import Foundation

class PushTokenRestClient {
    
    public static let shared = PushTokenRestClient()
    var semaphore = DispatchSemaphore (value: 0)
    var sessionCookieValue: String?
    var sessionSsoCookieValue: String?
    var rememberMeCookieValue: String?
    var isDuringSync = false
    var canDoRequest: Bool {
        return !isDuringSync && sessionCookieValue != nil && rememberMeCookieValue != nil && sessionSsoCookieValue != nil
    }
    
    func registerToken(username: String, token: String, baseUrl: URL, completion: @escaping (Bool) -> Void) {
        let params = ["username": username, "token": token, "type": "ios"]
        let registerTokenUrl = URL(string: baseUrl.absoluteString.serverDomainWithProtocolAndPort! + "/rest/private/v1/messaging/device")!
        print("==== registerTokenUrl ========> \(registerTokenUrl)")
        print("==== Params ==================> \(params)")
        let request = createRequest(url: registerTokenUrl, method: "POST", data: try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted))
        doRequest(request, completion: completion)
    }
    
    func unregisterToken(token: String, baseUrl: URL, completion: @escaping (Bool) -> Void) {
        let unregisterTokenUrl = URL(string: baseUrl.absoluteString.serverDomainWithProtocolAndPort! + "/rest/private/v1/messaging/device/\(token)")!
        print("unregisterTokenUrl ========> \(unregisterTokenUrl)")
        let request = createRequest(url: unregisterTokenUrl, method: "DELETE", data: nil)
        doRequest(request) { result in
            if result {
                self.sessionSsoCookieValue = nil
                self.sessionCookieValue = nil
                self.rememberMeCookieValue = nil
            }
            completion(result)
        }
    }
    
    private func createRequest(url: URL, method: String, data: Data?) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: Config.timeout)
        var headers = ["Content-Type": "application/json"]
        if let sessionCookieValue = sessionCookieValue, let rememberMeCookieValue = rememberMeCookieValue, let sessionSsoCookieValue = sessionSsoCookieValue {
            headers["Cookie"] = "\(Cookies.session.rawValue)=\(sessionCookieValue); \(Cookies.rememberMe.rawValue)=\(rememberMeCookieValue); \(Cookies.sessionSso.rawValue)=\(sessionSsoCookieValue)"
        }
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        request.httpBody = data
        return request
    }
    
    private func doRequest(_ request: URLRequest, completion: @escaping (Bool) -> Void) {
        guard canDoRequest else { return }
        isDuringSync = true
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.isDuringSync = false
            if let error = error {
                print("---REST:\tPush token request has failed \(error.localizedDescription)")
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    print("---REST:\tPush token request completed succesfully")
                    self.semaphore.signal()
                    completion(true)
                    return
                default:
                    self.semaphore.signal()
                    print("---REST:\tPush token request has failed. Server response: \(response.debugDescription) ---> Answered on request: \(request.debugDescription) : \((request.allHTTPHeaderFields ?? [:]).debugDescription)")
                }
            }
            self.semaphore.signal()
            completion(false)
        }.resume()
        semaphore.wait()
    }
}
