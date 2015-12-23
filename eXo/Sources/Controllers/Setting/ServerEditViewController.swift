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

class ServerEditViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonConstraintToBottom: NSLayoutConstraint!
    let kDeleteButtonBottomMargin:CGFloat = 30.0
    
    @IBOutlet weak var textView: PlaceholderTextView!
    var server:Server!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = server.serverURL
        textView.placeholder = NSLocalizedString("OnBoarding.Message.EnterURL", comment: "")
        Tool.applyBorderForView(self.deleteButton)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        
    }
    
    //MARK : User Action 
    @IBAction func saveAction(sender: AnyObject) {
        save()
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        delete()
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if  (text.characters.last == "\n" ){
            textView.resignFirstResponder()
            save()
            return false
        } else {
            return true
        }
    }
    

    func save () {
        //verification of URL, http is the default protocol
        Tool.verificationServerURL(textView.text, handleSuccess: { (server) -> Void in
            self.server = server
            ServerManager.sharedInstance.addServer(server)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    func delete() {
        //Ask for confirmation first
        let alertController = UIAlertController(title: NSLocalizedString("Setting.Title.DeleteServer", comment: ""), message: NSLocalizedString("Setting.Message.DeleteServer", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Word.Cancel", comment: ""), style: UIAlertActionStyle.Cancel) { (cancelAction) -> Void in
        }
        alertController.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Word.OK", comment: ""), style: UIAlertActionStyle.Destructive) { (confirmAction) -> Void in
            ServerManager.sharedInstance.removeServer(self.server);
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        alertController.addAction(confirmAction)
        self.presentViewController(alertController, animated: false, completion: nil)

    }
    
    //MARK : KeyBoard handle
    // Set up the position of the delete button to a visiable position (on portrait only)

    func keyboardWillShow(notification: NSNotification) {
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) == true {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.layoutIfNeeded()
                // Animate the movement of the deleteButton
                UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.LayoutSubviews, animations: { () -> Void in
                    self.deleteButtonConstraintToBottom.constant = keyboardSize.height + self.kDeleteButtonBottomMargin
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        } else {
            // Dont change the position of the delete Button in lanscape mode
            self.deleteButtonConstraintToBottom.constant = kDeleteButtonBottomMargin
        }
    }
    // Re-initialize the position of the Delete Button when the keyboard is off.
    func keyboardWillHide(notification: NSNotification) {
            self.view.layoutIfNeeded()
            UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.LayoutSubviews, animations: { () -> Void in
                self.deleteButtonConstraintToBottom.constant = self.kDeleteButtonBottomMargin
                self.view.layoutIfNeeded()
                }, completion: nil)
        
    }        


    
    /*
    // MARK: - Table View Datasource & Delegate
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Setting.Title.ServerInfo",comment:"")
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ServerInfo", forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = NSLocalizedString("Setting.Title.PlatformVersion", comment: "")
            cell.detailTextLabel?.text = server.platformVersion
            break
        case 1:
            cell.textLabel?.text = NSLocalizedString("Setting.Title.Edition", comment: "")
            cell.detailTextLabel?.text = server.platformEdition
            break
        case 2:
            cell.textLabel?.text = NSLocalizedString("Setting.Title.Secured", comment: "")
            cell.detailTextLabel?.text = server.serverURL.rangeOfString("https://") != nil ? "YES" : "NO"
            break
        case 3:
            cell.textLabel?.text = NSLocalizedString("Setting.Title.BuildNumber", comment: "")
            cell.detailTextLabel?.text = server.platformBuildNumber
            break
        case 4:
            cell.textLabel?.text = NSLocalizedString("Setting.Title.Revision", comment: "")
            cell.detailTextLabel?.text = server.platformRevision
            break

        default:
            break
        }
        return cell
    }
    
}
