//
//  InputAccountViewController.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/28/15.
//  Copyright © 2015 eXo. All rights reserved.
//

import UIKit

class InputAccountViewController: UIViewController, AccountSelectorDelegate {

    var account: Account?
    var delegate:AccountSelectorDelegate?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serverURLLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverURLLabel.text = (account?.serverURL)!.stringURLWithoutProtocol()
        usernameTextField.text = account?.userName
        passwordTextField.text = account?.password
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if (usernameTextField.text != nil && usernameTextField.text?.characters.count > 0) {
            account?.userName = usernameTextField.text
            
        }
        if (passwordTextField.text != nil && passwordTextField.text?.characters.count > 0) {
            account?.password = passwordTextField.text
        }
        if (delegate != nil) {
            delegate?.accountSelector!(nil, didSelectAccount: account!)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
