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
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var credentialView: UIView!
    

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLoginView()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor(hex: 0xF0F0F0)
    }
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func setupLoginView() {
        //serverURLLabel.text = (account?.serverURL)!.stringURLWithoutProtocol()
        usernameTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        loginBtn.layer.cornerRadius = 5
        credentialView.layer.cornerRadius = 10
        usernameTextField.text = account?.userName
        passwordTextField.text = account?.password
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

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
