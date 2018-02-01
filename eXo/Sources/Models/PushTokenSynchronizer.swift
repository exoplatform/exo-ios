//
//  PushTokenSynchronizer.swift
//  eXo
//
//  Created by Paweł Walczak on 29.01.2018.
//  Copyright © 2018 eXo. All rights reserved.
//

import Foundation

class PushTokenSynchronizer {
    
    public static let shared = PushTokenSynchronizer()
    
    var username: String? {
        didSet {
            if username != oldValue || !isSynchronized {
                trySynchronizeToken()
            }
        }
    }
    
    var url: String? {
        didSet {
            if url != oldValue || !isSynchronized {
                trySynchronizeToken()
            }
        }
    }
    
    var token: String? {
        didSet {
            if token != oldValue || !isSynchronized {
                trySynchronizeToken()
            }
        }
    }
    
    private var isSynchronized = false
    
    private init() {}
    
    func trySynchronizeToken() {
        guard let username = self.username, let urlString = self.url, let url = URL(string: urlString), let token = self.token else { return }
        PushTokenRestClient.shared.registerToken(username: username, token: token, baseUrl: url) { result in
            self.isSynchronized = result
        }
    }
    
    func tryDestroyToken() {
        guard let urlString = self.url, let url = URL(string: urlString), let token = self.token else { return }
        PushTokenRestClient.shared.unregisterToken(token: token, baseUrl: url) { result in
            if result {
                self.isSynchronized = false
                self.username = nil
                self.url = nil
            }
        }
    }
}
