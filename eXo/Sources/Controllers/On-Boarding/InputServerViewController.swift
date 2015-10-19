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


struct TableViewConfig {
}

class InputServerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    // MARK: Constants
    
    let kCellHeight:CGFloat = 50.0
    let kHeaderHeight:CGFloat = 30.0

    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: PlaceholderTextView!
    var selectedServer : Server?
    
    // MARK: View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        Get the list of server from NSUserDefault
        */
        textView.placeholder = NSLocalizedString("Enter your intranet URL", comment: "")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // the navigation controller is alway hidden in this screen
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.topViewController?.title = NSLocalizedString("Sign in to eXo", comment:"")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Input Text View Handle
    
    //detect when the return key is pressed
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if  (text.characters.last == "\n" ){
            //dismiss the keyboard
            textView.resignFirstResponder()
            //verification of URL, http is the default protocol
            var serverURL = textView.text
            if ( serverURL.rangeOfString("http://") == nil && serverURL.rangeOfString("https://") == nil ) {
                serverURL = "http://" + serverURL
            }
            let platformInfoURL = serverURL + "/rest/platform/info"
            
            let url = NSURL.init(string: platformInfoURL)
            if (url != nil) {
                SVProgressHUD.showWithMaskType(.Black)
                let operationQueue = NSOperationQueue.init()
                operationQueue.name = "URLVerification"
                let request = NSURLRequest.init(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 1000.0)

                NSURLConnection.sendAsynchronousRequest(request, queue: operationQueue, completionHandler: { (response, data, error) -> Void in
                    // dismiss the HUD
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        SVProgressHUD.dismiss()
                    })
                 
                    if (error == nil) {
                        let statusCode = (response as! NSHTTPURLResponse).statusCode
                        if (statusCode >= 200  && statusCode < 300) {
                            // Check platform version
                            let json = JSON(data: data!)
                            if let platformVersion = json["platformVersion"].string {
                                let version = (platformVersion as NSString).floatValue
                                if (version >= Config.supportVersion){
                                    self.selectedServer = Server (serverURL: serverURL)
                                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                        self.performSegueWithIdentifier("selectServerSegue", sender: serverURL)
                                    })
                                    
                                } else {
                                    // this application supports only platform version 4.3 or later
                                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                        self.showPlatformVersionAlert()
                                    })
                                }
                            }
                            
                        } else {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.showServerURLErrorAlert()
                            })
                        }
                    } else {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showServerURLErrorAlert()
                        })
                    }
                })
            } else {
                self.showServerURLErrorAlert()
            }
        }
        return true;
    }
    
    func showPlatformVersionAlert () {
        let alertView = UIAlertView.init(title: NSLocalizedString("Platform version not supported", comment:""), message: NSLocalizedString("The application only supports Platform version 4.3 or later",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("OK",comment:""))
        alertView.show()
    }
    func showServerURLErrorAlert () {
    
        let alertView = UIAlertView.init(title: NSLocalizedString("Server URL error", comment:""), message: NSLocalizedString("Unable to connect the server",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("OK",comment:""))
        
        alertView.show()
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
        return kHeaderHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kCellHeight
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ServerCell", forIndexPath: indexPath)
        cell.textLabel?.text =  (ServerManager.sharedInstance.serverList?[indexPath.row] as! Server).serverURL
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Recents",comment:"")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    /*
    // MARK: - Navigation
    // selectServerSegue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath:NSIndexPath? = self.tableView.indexPathForSelectedRow
        if (indexPath != nil) {
            self.selectedServer = ServerManager.sharedInstance.serverList?[indexPath!.row] as? Server
            self.selectedServer?.lastConnection = NSDate().timeIntervalSince1970
        }
        ServerManager.sharedInstance.addServer(self.selectedServer!)

        //TODO setup Destination VC
    }
}
