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
        let groupUserDefaults = NSUserDefaults(suiteName: ShareExtension.NSUserDefaultSuite)
        let list = groupUserDefaults!.valueForKey(ShareExtension.AllUserNameKey) as? NSArray
        if (list == nil) {
            return NSMutableArray ()
        }
        let servers = NSMutableArray ()
        for dict in list! {
            let s:Server = Server (serverDictionary: dict as! NSDictionary)
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
    
    func isExist (server : Server) -> Bool {
        let foundServer:Server? = self.findServerByURL(server.serverURL)
        return foundServer != nil
    }
    
    func findServerByURL (serverURL : String) -> Server? {
        if (serverList != nil ){
            for s in serverList! {
                if (s as! Server).serverURL == serverURL {
                    return s as? Server
                }
            }
        }
        return nil
    }
    
    func addServer (server : Server ) {
        
        let foundServer:Server? = self.findServerByURL(server.serverURL)
        if (foundServer == nil) {
            serverList.addObject(server)
        } else {
            //update attributed
            foundServer?.setDictionary(server.toDictionary())
        }
        self.saveServerList()
        
    }
    
    //Remove a server from servers list
    func removeServer (server : Server) {
        serverList.removeObject(server)
        self.saveServerList()
    }
    
    func saveServerList () {
        if (serverList != nil) {
            self.sortServerList()
            let list = NSMutableArray ()
            for server in serverList {
                list.addObject((server as! Server).toDictionary())
            }
            let groupUserDefaults = NSUserDefaults(suiteName: ShareExtension.NSUserDefaultSuite)
            groupUserDefaults?.setObject(list, forKey: ShareExtension.AllUserNameKey)
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
                    if (server as! Server).serverURL == Config.communityURL {
                        // A different Logo for eXo Community
                        items.addObject(UIApplicationShortcutItem.init(type: ShortcutType.connectRecentServer, localizedTitle: NSLocalizedString("Shortcut.Title.ConnnecteXoTribe", comment:""), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "eXoTribeLogo"), userInfo: (server as! Server).toDictionary() as [NSObject : AnyObject]))
                    } else {
                        // A common Logo for the others servers
                        items.addObject(UIApplicationShortcutItem.init(type: ShortcutType.connectRecentServer, localizedTitle: NSLocalizedString("Shortcut.Title.ConnectTo", comment:""), localizedSubtitle: (server as! Server).natureName(), icon: UIApplicationShortcutIcon(templateImageName: "server"), userInfo: (server as! Server).toDictionary() as [NSObject : AnyObject]))
                        
                    }
                
                }
            }
        } else {
            // when the list is empty
            let item = UIApplicationShortcutItem.init(type: ShortcutType.addNewServer, localizedTitle: NSLocalizedString("Shortcut.Title.AddServer", comment:""), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .Add), userInfo: nil)
            items.addObject(item)
        }
        UIApplication.sharedApplication().shortcutItems = items as NSArray as? [UIApplicationShortcutItem]

    }

}
