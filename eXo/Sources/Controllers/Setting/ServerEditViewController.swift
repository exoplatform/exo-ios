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
import SVProgressHUD
import SwiftyJSON

class ServerEditViewController: UIViewController {

    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonConstraintToBottom: NSLayoutConstraint!
    let kDeleteButtonBottomMargin:CGFloat = 20.0
    
    @IBOutlet weak var textView: PlaceholderTextView!
    var server:Server!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = server.serverURL
        textView.placeholder = NSLocalizedString("OnBoarding.Message.EnterURL", comment: "")
        Tool.applyBorderForView(self.deleteButton)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardDidHideNotification, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        save()
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
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

    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if  (text.characters.last == "\n" ){
            save()
            textView.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    func save () {
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
            let request = NSURLRequest.init(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: Config.timeout)
            
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
                            if (version >= Config.minimumPlatformVersionSupported){
                                self.server.serverURL = serverURL
                                ServerManager.sharedInstance.saveServerList()
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    self.navigationController?.popViewControllerAnimated(true)
                                })
                                
                            } else {
                                // this application supports only platform version 4.3 or later
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    Tool.showErrorMessageForCode(ConnectionError.ServerVersionNotSupport)
                                })
                            }
                        } else {
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                Tool.showErrorMessageForCode(ConnectionError.ServerVersionNotFound)
                            })
                        }
                        
                    } else {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            Tool.showErrorMessageForCode(ConnectionError.URLError)
                        })
                    }
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        Tool.showErrorMessageForCode(ConnectionError.URLError)
                    })
                }
            })
        } else {
            Tool.showErrorMessageForCode(ConnectionError.URLError)
        }
    }
    
    //MARK : KeyBoard handle
    // Set up the position of the delete button to a visiable position (on portrait only)

    func keyboardWillShow(notification: NSNotification) {
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
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


}
