//
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
