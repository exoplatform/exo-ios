//
//  AddDomainViewController.swift
//  eXo
//
//  Created by eXo Development on 14/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class AddDomainViewController: UIViewController,UITextFieldDelegate {

    // MARK: - Outlets.
        
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var suffixUrlTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var companyWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Variable.

    var selectedServer : Server?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        containerView.addBorderWith(width: 1, color: .lightGray, cornerRadius: 6)
        companyTextField.delegate = self
        companyWidthConstraint.constant = companyTextField.intrinsicContentSize.width
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonTappee(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextField Delegate .

    func textFieldDidBeginEditing(_ textField: UITextField) {
        companyTextField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == companyTextField {
            companyWidthConstraint.constant = textField.intrinsicContentSize.width
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == companyTextField {
            companyWidthConstraint.constant = textField.intrinsicContentSize.width
        }
    }
        
    @IBAction func clearButtonTapped(_ sender: Any) {
        companyTextField.isHidden = true
        suffixUrlTextField.text = ""
        suffixUrlTextField.becomeFirstResponder()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        // dismiss the keyboard
        view.endEditing(true)
        // verification of URL, http is the default protocol
        if let company = companyTextField.text, let sufixUrl = suffixUrlTextField.text {
            print(company,sufixUrl)
            Tool.verificationServerURL(company+sufixUrl, handleSuccess: { (serverURL) -> Void in
                self.selectedServer = Server (serverURL: serverURL)
                OperationQueue.main.addOperation({ () -> Void in
                    ServerManager.sharedInstance.addEditServer(self.selectedServer!)
                    self.selectedServer?.lastConnection = Date().timeIntervalSince1970
                    UserDefaults.standard.setValue(self.selectedServer?.serverURL, forKey: "serverURL")
                    self.dismiss(animated: true) {
                        if let serverURL = self.selectedServer?.serverURL {
                            self.postNotificationWith(key: .addDomainKey, info: ["serverURL" : serverURL])
                        }
                    }
                })
            })
        }
    }
}

