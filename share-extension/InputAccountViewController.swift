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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l < r
	case (nil, _?):
		return true
	default:
		return false
	}
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
	switch (lhs, rhs) {
	case let (l?, r?):
		return l > r
	default:
		return rhs < lhs
	}
}


class InputAccountViewController: UIViewController, AccountSelectorDelegate {

	@objc var account: Account?
	@objc var delegate:AccountSelectorDelegate?

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

	@IBAction func loginAction(_ sender: AnyObject) {

		if let username = usernameTextField.text, !username.isEmpty {
			account?.userName = username
		}
		if let password = passwordTextField.text, !password.isEmpty {
			account?.password = password
		}

		if (delegate != nil) {
			delegate?.accountSelector!(nil, didSelect: account!)
		}
		self.navigationController?.popToRootViewController(animated: true)

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

extension String {

    func stringURLWithoutProtocol () -> String {
        var stringURLWithoutProtocol = self.replacingOccurrences(of: "http://", with: "")
        stringURLWithoutProtocol = stringURLWithoutProtocol.replacingOccurrences(of: "https://", with: "")
        return stringURLWithoutProtocol
    }
    
}
