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

    let kTableHeaderViewIdentifier:String = "table-header"
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: PlaceholderTextView!
    
    @IBOutlet weak var recentServerHeader: UIView!
    
    var selectedServer : Server?
    
    
    // MARK: View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        textView.placeholder = NSLocalizedString("OnBoarding.Message.EnterURL", comment: "")
        self.tableView.register(UINib(nibName: "TableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: kTableHeaderViewIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // the navigation controller is alway shown in this screen
        self.navigationItem.title = NSLocalizedString("OnBoarding.Title.SignInToeXo", comment:"")
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = "" // to remove the longue text of the Back button (on the left of navigation bar)
    }
    
    // MARK: Input Text View Handle
    
    //detect when the return key is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if  (text.characters.last == "\n" ){
            //dismiss the keyboard
            textView.resignFirstResponder()
            //verification of URL, http is the default protocol
            Tool.verificationServerURL(textView.text, handleSuccess: { (serverURL) -> Void in
                self.selectedServer = Server (serverURL: serverURL)
                OperationQueue.main.addOperation({ () -> Void in
                    self.performSegue(withIdentifier: "selectServerSegue", sender: serverURL)
                })
            })
        }
        return true;
    }
    
    /*
    // MARK: - Table View Datasource & Delegate
    */
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( ServerManager.sharedInstance.serverList != nil) {
            return ServerManager.sharedInstance.serverList!.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Config.kTableHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.kTableCellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerCell", for: indexPath)
        cell.textLabel?.text =  (ServerManager.sharedInstance.serverList?[indexPath.row] as! Server).serverURL.stringURLWithoutProtocol()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return recentServerHeader
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation
    // selectServerSegue
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let indexPath:IndexPath? = self.tableView.indexPathForSelectedRow
        if (indexPath != nil) {
            self.selectedServer = ServerManager.sharedInstance.serverList?[indexPath!.row] as? Server
            self.selectedServer?.lastConnection = Date().timeIntervalSince1970
        }
        ServerManager.sharedInstance.addEditServer(self.selectedServer!)
        // Open the selected server in the WebView
        let homepageVC = segue.destination as! HomePageViewController
        homepageVC.serverURL = self.selectedServer?.serverURL
        self.tableView.reloadData()
    }
}
