//
//  InputServerViewController.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/16/15.
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
import SVProgressHUD
import SwiftyJSON

class InputServerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    let kTableHeaderViewIdentifient:String = "table-header"
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: PlaceholderTextView!
    
    @IBOutlet weak var recentServerHeader: UIView!
    
    var selectedServer : Server?
    
    
    // MARK: View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clearColor()
        textView.placeholder = NSLocalizedString("OnBoarding.Message.EnterURL", comment: "")
        self.tableView.registerNib(UINib(nibName: "TableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kTableHeaderViewIdentifient)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // the navigation controller is alway shown in this screen
        self.navigationItem.title = NSLocalizedString("OnBoarding.Title.SignInToeXo", comment:"")
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = "" // to remove the longue text of the Back button (on the left of navigation bar)
    }
    
    // MARK: Input Text View Handle
    
    //detect when the return key is pressed
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if  (text.characters.last == "\n" ){
            //dismiss the keyboard
            textView.resignFirstResponder()
            //verification of URL, http is the default protocol
            Tool.verificationServerURL(textView.text, handleSuccess: { (serverURL) -> Void in
                self.selectedServer = Server (serverURL: serverURL)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.performSegueWithIdentifier("selectServerSegue", sender: serverURL)
                })
            })
        }
        return true;
    }
    
    /*
    // MARK: - Table View Datasource & Delegate
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( ServerManager.sharedInstance.serverList != nil) {
            return ServerManager.sharedInstance.serverList!.count
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Config.kTableHeaderHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Config.kTableCellHeight
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ServerCell", forIndexPath: indexPath)
        cell.textLabel?.text =  (ServerManager.sharedInstance.serverList?[indexPath.row] as! Server).serverURL.stringURLWithoutProtocol()
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return recentServerHeader
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation
    // selectServerSegue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let indexPath:NSIndexPath? = self.tableView.indexPathForSelectedRow
        if (indexPath != nil) {
            self.selectedServer = ServerManager.sharedInstance.serverList?[indexPath!.row] as? Server
            self.selectedServer?.lastConnection = NSDate().timeIntervalSince1970
        }
        ServerManager.sharedInstance.addServer(self.selectedServer!)
        //TODO setup Destination VC
        let homepageVC = segue.destinationViewController as! HomePageViewController
        homepageVC.serverURL = self.selectedServer?.serverURL
        self.tableView.reloadData()
    }
}
