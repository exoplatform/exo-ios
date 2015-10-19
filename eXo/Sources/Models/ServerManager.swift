//
//  ServerManager.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/20/15.
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

import UIKit

class ServerManager  {
    
    //Singleton class
    static let sharedInstance = ServerManager ()
        
    var serverList:NSMutableArray!
    
    init () {
        /*
        Get the list of server from NSUserDefault
        */
        serverList = serverListFromNSUserDefault()
    }
    
    
    func serverListFromNSUserDefault () -> NSMutableArray {
        let list = NSUserDefaults.standardUserDefaults().valueForKey(UserDefaultConfig.listServerKey) as? NSArray
        if (list == nil) {
            return NSMutableArray ()
        }
        let servers = NSMutableArray ()
        for dict in list! {
            let s:Server = Server (serverURL: dict.valueForKey(ServerKey.serverURL) as! String , username: dict.valueForKey(ServerKey.username) as! String, lastConnection: dict.valueForKey(ServerKey.lastConnection) as! Double)
            servers.addObject(s)
        }
        return servers
    }
    
    func reloadServerList () {
        serverList = self.serverListFromNSUserDefault()
    }
    
    
    func sortServerList () {
        serverList.sortUsingComparator { (server1, server2) -> NSComparisonResult in
            if (server1 as! Server).lastConnection >= (server2 as! Server).lastConnection {
                return NSComparisonResult.OrderedAscending
            } else {
                return NSComparisonResult.OrderedDescending
            }
        }
    }
    
    func addServer (server : Server ) {
        
        var exist = false
        if (serverList != nil ){
            for s in serverList! {
                if (s as! Server).serverURL == server.serverURL {
                    (s as! Server).lastConnection = server.lastConnection
                    exist = true
                }
            }
        }
        if (!exist) {
            serverList.addObject(server)
        }
        self.saveServerList()
    }
    
    func saveServerList () {
        if (serverList != nil) {
            self.sortServerList()
            let list = NSMutableArray ()
            for server in serverList {
                list.addObject((server as! Server).toDictionary())
            }
            NSUserDefaults.standardUserDefaults().setObject(list, forKey: UserDefaultConfig.listServerKey)
        }
        
    }
    
}
