//
//  StringExtension.swift
//  eXo
//
//  Created by Paweł Walczak on 29.01.2018.
//  Copyright © 2018 eXo. All rights reserved.
//

import Foundation

extension String {
    
    func isBlankOrEmpty() -> Bool {
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    /*
     Return the serverURL with protocol & port (if need)
     example: serverURL = http://localhost:8080/portal/intranet
     -> full domain with protocol & port = http://localhost:8080
     */
    var serverDomainWithProtocolAndPort: String? {
        guard let url = URL(string: self), let scheme = url.scheme, let host = url.host else { return nil }
        var fullDomain = scheme + "://" + host
        if let port = url.port {
            fullDomain += ":\(port)"
        }
        return fullDomain
    }
    
}
