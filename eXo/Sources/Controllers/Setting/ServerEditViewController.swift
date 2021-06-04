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

class ServerEditViewController: UIViewController, UITextViewDelegate {


	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var deleteButtonConstraintToBottom: NSLayoutConstraint!
	@IBOutlet weak var textView: PlaceholderTextView!

	let kDeleteButtonBottomMargin:CGFloat = 30.0
	var server:Server!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.textView.text = server.serverURL
		textView.placeholder = NSLocalizedString("OnBoarding.Message.EnterURL", comment: "")
		Tool.applyBorderForView(self.deleteButton)
		textView.delegate = self

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ServerEditViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ServerEditViewController.keyboardWillHide(_:)), name:UIResponder.keyboardDidHideNotification, object: nil)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardDidHideNotification, object: nil)

	}

	//MARK : User Action
	@IBAction func saveAction(_ sender: AnyObject) {
		save()
	}

	@IBAction func deleteAction(_ sender: AnyObject) {
		delete()
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if  (text.last == "\n" ){
			textView.resignFirstResponder()
			save()
			return false
		} else {
			return true
		}
	}

	func save () {
		//verification of URL, http is the default protocol
		Tool.verificationServerURL(textView.text, handleSuccess: { (serverURL) -> Void in
			let tempServer:Server = Server(serverURL: serverURL)
			let existingServer:Server! = ServerManager.sharedInstance.getServerIfExists(tempServer)
			if (existingServer != nil && !existingServer.isEqual(self.server)) {
				// if another server already has the new URL, delete it
				ServerManager.sharedInstance.removeServer(existingServer)
			}
			self.server.serverURL = serverURL
			ServerManager.sharedInstance.saveServerList()
			OperationQueue.main.addOperation({ () -> Void in
				self.navigationController?.popViewController(animated: true)
			})
		})
	}

	func delete() {
		//Ask for confirmation first
        let alertController = UIAlertController(title: NSLocalizedString("Setting.Title.DeleteServer", comment: ""), message: NSLocalizedString("Setting.Message.DeleteServer", comment: ""), preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Word.Cancel", comment: ""), style: UIAlertAction.Style.cancel) { (cancelAction) -> Void in
		}
		alertController.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Word.OK", comment: ""), style: UIAlertAction.Style.destructive) { (confirmAction) -> Void in
			ServerManager.sharedInstance.removeServer(self.server);
			self.navigationController?.popViewController(animated: true)

		}
		alertController.addAction(confirmAction)
		self.present(alertController, animated: false, completion: nil)

	}

	//MARK : KeyBoard handle
	// Set up the position of the delete button to a visiable position (on portrait only)

	@objc func keyboardWillShow(_ notification: Notification) {
        if UIDevice.current.orientation.isPortrait == true {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
				self.view.layoutIfNeeded()
				// Animate the movement of the deleteButton
                UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIView.KeyframeAnimationOptions.layoutSubviews, animations: { () -> Void in
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
	@objc func keyboardWillHide(_ notification: Notification) {
		self.view.layoutIfNeeded()
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIView.KeyframeAnimationOptions.layoutSubviews, animations: { () -> Void in
			self.deleteButtonConstraintToBottom.constant = self.kDeleteButtonBottomMargin
			self.view.layoutIfNeeded()
		}, completion: nil)

	}


}
