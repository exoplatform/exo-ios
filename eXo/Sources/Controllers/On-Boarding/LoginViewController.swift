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

class LoginViewController: UITableViewController {

    let kCellHeight:CGFloat = 80.0
    var defaultServer:Server?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (ServerManager.sharedInstance.serverList.count > 0){
            defaultServer = ServerManager.sharedInstance.serverList.firstObject as? Server
        } else {
            defaultServer = Server(serverURL: Config.communityURL)
        }
        self.tableView.reloadData()
        // the navigation controller is alway shown in this screen
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = NSLocalizedString("OnBoarding.Title.SignInToeXo", comment:"")
    }
    
    /*
    // MARK: - Table View Datasource & Delegate
    // Table with 2 sections (1 Row each)
     - Connect to the most recent server
     - Open the Input Server to select an other server
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return NSLocalizedString("OnBoarding.Title.MostRecentServer", comment:"")
        } else {
            return ""
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kCellHeight
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("LastServerCell", forIndexPath: indexPath)
            cell!.textLabel?.text = (defaultServer?.serverURL)!.stringURLWithoutProtocol()
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("OthersServerCell", forIndexPath: indexPath)
            cell!.textLabel?.text = NSLocalizedString("OnBoarding.Title.Others", comment: "")
        }
        return cell!
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.navigationController?.topViewController?.title = ""
        if (segue.identifier == "openDefaultServer") {
            defaultServer?.lastConnection = NSDate().timeIntervalSince1970
            ServerManager.sharedInstance.addServer(defaultServer!)
            //setup Destination VC
            let homepageVC = segue.destinationViewController as! HomePageViewController
            homepageVC.serverURL = defaultServer?.serverURL
        }
    }

}
