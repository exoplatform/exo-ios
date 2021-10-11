//
//  PushTokenSynchronizer.swift
//  eXo
//
//  Created by Paweł Walczak on 29.01.2018.
//  Copyright © 2018 eXo. All rights reserved.
//

import Foundation
import UIKit

class PushTokenSynchronizer {
    
    public static let shared = PushTokenSynchronizer()
    
    var username: String?
    var url: String?
    var token: String?
    private var isSynchronized = false
    
    private init() {}
    
    func trySynchronizeToken() {
        guard !isSynchronized, let username = self.username, let urlString = self.url, let url = URL(string: urlString), let token = self.token else { return }
        PushTokenRestClient.shared.registerToken(username: username, token: token, baseUrl: url) { result in
            self.isSynchronized = result
        }
    }
    
    func tryDestroyToken() {
        guard isSynchronized, let urlString = self.url, let url = URL(string: urlString), let token = self.token else { return }
        PushTokenRestClient.shared.unregisterToken(token: token, baseUrl: url) { result in
            if result {
                UIApplication.shared.applicationIconBadgeNumber = 0
                self.isSynchronized = false
                self.username = nil
                self.url = nil
            }
        }
    }
}
