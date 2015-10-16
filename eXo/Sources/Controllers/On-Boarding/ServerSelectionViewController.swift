//
//  ServerSelectionViewController.swift
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

import UIKit

class ServerSelectionViewController: UIViewController {

    @IBOutlet weak var mostRecentServerLabel: UILabel!
    var defaultServerURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        Get the list of server from NSUserDefault
        */
        let listServers:NSArray? = NSUserDefaults.standardUserDefaults().valueForKey(UserDefaultConfig.listServerKey) as? NSArray
        if (listServers?.count > 0){
            defaultServerURL = (listServers!.lastObject as! NSDictionary).valueForKey(ServerKey.serverURL) as? String
        } else {
            defaultServerURL = Config.communityURL
        }
        // Do not show the protocol to save place
        mostRecentServerLabel.text = self.stringURLWithoutProtocol(defaultServerURL!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation
    Could be:
    - Open HomePage with default Server (segue: openDefautServer)
    - Open HomePage with community server & point to register page (segue:openRegisterPage)
    - Open Input server screen to choose an other server (segue:openInputServer)
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    
    //Remove the protocol (http:// or https://) of a URL in string
    func stringURLWithoutProtocol (stringURLWithProtocol : String) -> String {
        var stringURLWithoutProtocol = stringURLWithProtocol.stringByReplacingOccurrencesOfString("http://", withString: "");
        stringURLWithoutProtocol = stringURLWithoutProtocol.stringByReplacingOccurrencesOfString("https://", withString: "")
        return stringURLWithoutProtocol
    }
}
