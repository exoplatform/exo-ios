//
//  Server.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/15/15.
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


import Foundation

struct ServerKey {
    static let serverURL = "serverURL"
    static let username = "username"
    static let lastConnection = "lastConnection"
}

struct ShortcutTitleConfig {
    static let maximumCharacters:Int = 29
    static let prefixCharacters:Int = 8
    static let suffixCharacters:Int = 15
}


class Server {

    var serverURL:String = ""
    var username:String = ""
    var lastConnection:Double = 0
    
    init () {
        
    }
    
    init (serverURL: String) {
        self.serverURL = serverURL.lowercased()
        self.lastConnection = Date ().timeIntervalSince1970
    }
    
    init (serverURL: String, username: String, lastConnection:Double) {
        self.serverURL = serverURL.lowercased()
        self.username  = username
        self.lastConnection = lastConnection
    }
    
    init (serverDictionary : NSDictionary) {
        let url:String = serverDictionary.value(forKey: ServerKey.serverURL) as! String
        self.serverURL = url.lowercased()
        self.username = serverDictionary.value(forKey: ServerKey.username) as! String
        self.lastConnection = serverDictionary.value(forKey: ServerKey.lastConnection) as! Double        
    }
    
    func toDictionary () -> NSDictionary {
        return [ ServerKey.serverURL:serverURL, ServerKey.username: username, ServerKey.lastConnection:lastConnection]
    }
    
    func natureName () -> String {
        let name: String = self.serverURL.stringURLWithoutProtocol()
        if (name.utf8.count > ShortcutTitleConfig.maximumCharacters) {
            var shortName = name.substring(to: name.characters.index(name.startIndex, offsetBy: ShortcutTitleConfig.prefixCharacters))
            shortName += "..."
            shortName += name.substring(from: name.characters.index(name.endIndex, offsetBy: -ShortcutTitleConfig.suffixCharacters))
            return shortName
        }
        return name
    }
    
    /**
     
    Check if an other server is equal to this server.

     */
    func isEqual (_ server : Server) -> Bool {
        let self_url = URL(string: self.serverURL)
        let url = URL(string: server.serverURL)
        if (self_url != nil && url != nil && self_url?.host != nil && url?.host != nil) {
           return self_url?.host == url?.host
        }
        return false
    }
}
