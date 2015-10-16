//
//  Server.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/15/15.
//  Copyright © 2015 eXo. All rights reserved.
//

import Foundation

struct ServerKey {
    static let serverURL = "serverURL"
}

class Server {

    var serverURL:String = ""
    var username:String = ""
    var lastConnected:Double = 0
    
    func toDictionary () -> NSDictionary {
        return [ "serverURL":serverURL, "username": username, "lastConnected":lastConnected]
    }
}
