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
    static let platformVersion = "platformVersion"
    static let platformEdition = "platformEdition"
    static let platformBuildNumber = "platformBuildNumber"
    static let platformRevision = "platformRevision"

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
    var platformVersion: String = ""
    var platformEdition: String = ""
    var platformBuildNumber: String = ""
    var platformRevision: String = ""
    init () {
        
    }
    
    init (serverURL: String) {
        self.serverURL = serverURL
        self.lastConnection = NSDate ().timeIntervalSince1970
    }
    
    init (serverURL: String, username: String, lastConnection:Double) {
        self.serverURL = serverURL
        self.username  = username
        self.lastConnection = lastConnection
    }
    
    init (serverDictionary : NSDictionary) {
        self.setDictionary(serverDictionary)
    }
        
    func setDictionary (serverDictionary : NSDictionary)  -> Void {
        self.serverURL = serverDictionary.valueForKey(ServerKey.serverURL) as! String
        self.username = serverDictionary.valueForKey(ServerKey.username) as! String
        self.lastConnection = serverDictionary.valueForKey(ServerKey.lastConnection) as! Double
        
        self.platformVersion = serverDictionary.valueForKey(ServerKey.platformVersion) as! String
        self.platformEdition = serverDictionary.valueForKey(ServerKey.platformEdition) as! String
        self.platformBuildNumber = serverDictionary.valueForKey(ServerKey.platformBuildNumber) as! String
        self.platformRevision = serverDictionary.valueForKey(ServerKey.platformRevision) as! String
   
    }
    
    func toDictionary () -> NSDictionary {
        return [ ServerKey.serverURL:serverURL, ServerKey.username: username, ServerKey.lastConnection:lastConnection, ServerKey.platformVersion:platformVersion, ServerKey.platformEdition: platformEdition, ServerKey.platformBuildNumber:platformBuildNumber , ServerKey.platformRevision:platformRevision ]
    }
    
    func natureName () -> String {
        let name: String = self.serverURL.stringURLWithoutProtocol()
        if (name.utf8.count > ShortcutTitleConfig.maximumCharacters) {
            var shortName = name.substringToIndex(name.startIndex.advancedBy(ShortcutTitleConfig.prefixCharacters))
            shortName += "..."
            shortName += name.substringFromIndex(name.endIndex.advancedBy(-ShortcutTitleConfig.suffixCharacters))
            return shortName
        }
        return name
    }
}
