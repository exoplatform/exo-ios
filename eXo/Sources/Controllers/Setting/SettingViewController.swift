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

class SettingViewController: UITableViewController {

    let kCellHeight:CGFloat = 80.0
    let kHeaderHeight:CGFloat = 30.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let indexPath = self.tableView.indexPathForSelectedRow
        let server:Server = ServerManager.sharedInstance.serverList![(indexPath?.row)!]
         as! Server
        let serverEditVC:ServerEditViewController =  segue.destinationViewController as! ServerEditViewController
        serverEditVC.server = server
    }


    
    /*
    // MARK: - Table View Datasource & Delegate
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        //servers & about section
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if ( ServerManager.sharedInstance.serverList != nil) {
                return ServerManager.sharedInstance.serverList!.count
            }
        }
        if (section == 1) {
            // about section: application version / help
            return 2;
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kCellHeight
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0 ) {
            let cell = tableView.dequeueReusableCellWithIdentifier("ServerCell", forIndexPath: indexPath)
            cell.textLabel?.text = (ServerManager.sharedInstance.serverList?[indexPath.row] as! Server).serverURL.stringURLWithoutProtocol()
            
            return cell
        }
        if (indexPath.row == 0 ) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingRightDetail", forIndexPath: indexPath)
            cell.textLabel?.text = NSLocalizedString("Setting.Title.ApplicationVersion", comment: "");
            //First get the nsObject by defining as an optional anyObject
            let version: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
            
            //Then just cast the object as a String, but be careful, you may want to double check for nil
            cell.detailTextLabel?.text = version as? String
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingHelp", forIndexPath: indexPath)
            cell.textLabel?.text = NSLocalizedString("Setting.Title.Help", comment: "");
            
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 :
            return NSLocalizedString("Setting.Title.Server",comment:"")
        case 1 :
            return NSLocalizedString("Setting.Title.About",comment:"")
        default :
            return ""
        }

    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.deleteServer(indexPath)
        }
    }
    
    func deleteServer(indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: NSLocalizedString("Setting.Title.DeleteServer", comment: ""), message: NSLocalizedString("Setting.Message.DeleteServer", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Word.Cancel", comment: ""), style: UIAlertActionStyle.Cancel) { (cancelAction) -> Void in
        }
        alertController.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Word.OK", comment: ""), style: UIAlertActionStyle.Destructive) { (confirmAction) -> Void in
            let server:Server = (ServerManager.sharedInstance.serverList?[indexPath.row])! as! Server
            ServerManager.sharedInstance.removeServer(server)
            self.tableView.reloadData()
            
        }
        alertController.addAction(confirmAction)
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.reloadData()
    }

}
