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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addurlLabel: UILabel!
    
    // MARK: - Variable.
    
    var selectedServer : Server?
    var textFieldToUse:UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    func setupView(){
        companyTextField.becomeFirstResponder()
        titleLabel.text = "Add your eXo".localized
        addurlLabel.text = "Enter your eXo URL".localized
        containerView.addBorderWith(width: 1, color: .lightGray, cornerRadius: 6)
        companyTextField.delegate = self
        suffixUrlTextField.delegate = self
        companyWidthConstraint.constant = companyTextField.intrinsicContentSize.width
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextField Delegate .
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == companyTextField {
            companyTextField.becomeFirstResponder()
            companyTextField.textAlignment = .left
        }else{
            suffixUrlTextField.becomeFirstResponder()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == companyTextField {
            companyTextField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.lowercased())
            let text = companyTextField.text! + string.lowercased()
            var width:CGFloat = 0
            if text.count >= 6 {
                if string == "" {
                    width = getWidth(text: text) - 15
                }else{
                    width = getWidth(text: text) - 10
                }
            }else{
                if string == "" {
                    width = getWidth(text: text) - 10
                }else{
                    width = getWidth(text: text)
                }
            }
            companyWidthConstraint.constant = width
            self.view.layoutIfNeeded()
            return false
        }else if textField == suffixUrlTextField {
            suffixUrlTextField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.lowercased())
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == companyTextField {
            companyWidthConstraint.constant = textField.intrinsicContentSize.width
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        companyTextField.text = ""
        companyTextField.isHidden = true
        suffixUrlTextField.text = ""
        suffixUrlTextField.becomeFirstResponder()
    }
    
    @IBAction func closeButtonTappee(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        // dismiss the keyboard
        view.endEditing(true)
        // check Internet connection
        checkConnectivity()
        // verification of URL, http is the default protocol
        if let company = companyTextField.text, let sufixUrl = suffixUrlTextField.text {
            print(company,sufixUrl)
            Tool.verificationServerURL(company+sufixUrl, delegate: self, handleSuccess: { (serverURL) -> Void in
                self.selectedServer = Server (serverURL: serverURL)
                OperationQueue.main.addOperation({ () -> Void in
                    ServerManager.sharedInstance.addEditServer(self.selectedServer!)
                    self.selectedServer?.lastConnection = Date().timeIntervalSince1970
                   // UserDefaults.standard.setValue(self.selectedServer?.serverURL, forKey: "serverURL")
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

