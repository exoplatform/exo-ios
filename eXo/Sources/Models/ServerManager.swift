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
        let groupUserDefaults = UserDefaults(suiteName: ShareExtension.NSUserDefaultSuite)
        let list = groupUserDefaults!.value(forKey: ShareExtension.AllUserNameKey) as? NSArray
        if (list == nil) {
            return NSMutableArray ()
        }
        let servers = NSMutableArray ()
        for dict in list! {
            let s:Server = Server (serverURL: (dict as AnyObject).value(forKey: ServerKey.serverURL) as! String , username: (dict as AnyObject).value(forKey: ServerKey.username) as! String, lastConnection: 0)
            if (((dict as AnyObject).value(forKey: ServerKey.lastConnection)) != nil) {
                // servers created on MOB v2.x don't have a last connection info
                s.lastConnection = (dict as AnyObject).value(forKey: ServerKey.lastConnection) as! Double
            }
            servers.add(s)
        }
        return servers
    }
    
    func reloadServerList () {
        serverList = self.serverListFromNSUserDefault()
    }
    
    
    func sortServerList () {
        serverList.sort (comparator: { (server1, server2) -> ComparisonResult in
            if (server1 as! Server).lastConnection >= (server2 as! Server).lastConnection {
                return ComparisonResult.orderedAscending
            } else {
                return ComparisonResult.orderedDescending
            }
        })
    }
    
    func isExist (_ server : Server) -> Bool {
        if (serverList != nil ){
            for s in serverList! {
                if (s as! Server).isEqual(server) {
                    (s as! Server).lastConnection = server.lastConnection
                    return true
                }
            }
        }
        return false
    }
    
    func getServerIfExists (_ server : Server) -> Server? {
        if (serverList != nil ){
            for s in serverList! {
                if (s as! Server).isEqual(server) {
                    (s as! Server).lastConnection = server.lastConnection
                    return (s as! Server)
                }
            }
        }
        return nil
    }
    
    func addEditServer (_ server : Server ) {
        let originalServer:Server! = self.getServerIfExists(server)
        if (originalServer == nil) {
            serverList.add(server)
        } else {
            originalServer.serverURL = server.serverURL
        }
        self.saveServerList()
    }
    
    //Remove a server from servers list
    func removeServer (_ server : Server) {
        serverList.remove(server)
        self.saveServerList()
    }
    
    func saveServerList () {
        if (serverList != nil) {
            self.sortServerList()
            let list = NSMutableArray ()
            for server in serverList {
                list.add((server as! Server).toDictionary())
            }
            let groupUserDefaults = UserDefaults(suiteName: ShareExtension.NSUserDefaultSuite)
            groupUserDefaults?.set(list, forKey: ShareExtension.AllUserNameKey)
            groupUserDefaults?.synchronize()
            
            if #available(iOS 9.0, *) {
                self.updateQuickAction()
            }
        }
    }
    
    /*
     Re-initialize the list of dynamic shortcuts
     2 Kind of shortcuts available:
     - Add New Server: availabel when the list of server is empty.
     - Open a Server: Link direct to the most recent Server (4 Maximum)
     */
    @available(iOS 9.0, *)
    func updateQuickAction () {
        let items:NSMutableArray = NSMutableArray()
        if (serverList.count > 0) {
            for server in serverList {
                if (items.count < Config.maximumShortcutAllow) {
                    if (Config.communityURL.contains((server as! Server).serverURL.stringURLWithoutProtocol())) {
                        // A different Logo and title for eXo Tribe website
                        items.add(UIApplicationShortcutItem.init(type: ShortcutType.connectRecentServer, localizedTitle: "Shortcut.Title.ConnnecteXoTribe".localized, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "eXoTribeLogo"), userInfo: ((server as! Server).toDictionary()) as? [String : NSSecureCoding]))
                    } else {
                        // A common Logo for the other servers
                        items.add(UIApplicationShortcutItem.init(type: ShortcutType.connectRecentServer, localizedTitle: "Shortcut.Title.ConnectTo".localized, localizedSubtitle: (server as! Server).natureName(), icon: UIApplicationShortcutIcon(templateImageName: "server"), userInfo: ((server as! Server).toDictionary()) as? [String : NSSecureCoding]))
                    }
                }
            }
        } else {
            // when the list is empty
            let item = UIApplicationShortcutItem.init(type: ShortcutType.addNewServer, localizedTitle: "Shortcut.Title.AddServer".localized, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
            items.add(item)
        }
        UIApplication.shared.shortcutItems = items as NSArray as? [UIApplicationShortcutItem]
    }
}
