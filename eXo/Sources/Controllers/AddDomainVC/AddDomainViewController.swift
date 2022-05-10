//
//  AddDomainViewController.swift
//  eXo
//
//  Created by eXo Development on 14/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

final class AddDomainViewController: UIViewController,UITextFieldDelegate {
    
    // MARK: - Outlets.
    
    @IBOutlet weak var inputUrlTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
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
        inputUrlTextField.becomeFirstResponder()
        titleLabel.text = "Add your eXo".localized
        addurlLabel.text = "Enter your eXo URL".localized
        containerView.addBorderWith(width: 1, color: .lightGray, cornerRadius: 6)
        inputUrlTextField.delegate = self
        inputUrlTextField.returnKeyType = UIReturnKeyType.go
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextField Delegate .
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputUrlTextField.becomeFirstResponder()
        inputUrlTextField.textAlignment = .left
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputUrlTextField.resignFirstResponder()
        addServer()
        return true
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        inputUrlTextField.text = ""
        inputUrlTextField.becomeFirstResponder()
    }
    
    @IBAction func closeButtonTappee(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addServer()
    }
    
    func addServer(){
        // dismiss the keyboard
        view.endEditing(true)
        // check Internet connection
        // verification of URL, http is the default protocol
        if let company = inputUrlTextField.text {
            print(company)
            if isInternetConnected(inWeb: false) {
                Tool.verificationServerURL(company, delegate: self, handleSuccess: { (serverURL) -> Void in
                    self.selectedServer = Server (serverURL: serverURL)
                    OperationQueue.main.addOperation({ () -> Void in
                        ServerManager.sharedInstance.addEditServer(self.selectedServer!)
                        self.selectedServer?.lastConnection = Date().timeIntervalSince1970
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
}

