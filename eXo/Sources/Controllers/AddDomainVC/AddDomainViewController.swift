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
    
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var actionContainerView: UIView!
    @IBOutlet weak var addImgView: UIImageView!
    
    // MARK: - Variable.

    var selectedServer : Server?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        self.addImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        domainTextField.delegate = self
        domainTextField.clearButtonMode = .always
        textViewContainer.addBorderWith(width: 1, color: .lightGray, cornerRadius: 6)
        let attributedStringFormule = NSMutableAttributedString()
        attributedStringFormule.append(text: "company", color: .lightGray, font: UIFont.init(name: "HelveticaNeue-Medium", size: 17)!)
        attributedStringFormule.append(text: ".exoplatform.com", color: .darkGray, font: UIFont.init(name: "HelveticaNeue-Medium", size: 17)!)
        domainTextField.attributedText = attributedStringFormule
        addButton.setBackgroundImage(UIImage(), for: .highlighted)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        domainTextField.resignFirstResponder()
    }
    
    // MARK: - UITextField Delegate.
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = domainTextField.text {
            if !text.isBlankOrEmpty() && text ==  "company.exoplatform.com"{
                domainTextField.text = ".exoplatform.com"
            }
            if !text.isEmpty && text.contains(" ") {
                domainTextField.text = ""
            }
        }
    }
    
    @IBAction func closeButtonTappee(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        // dismiss the keyboard
        domainTextField.resignFirstResponder()
        // verification of URL, http is the default protocol
        if let serverText = domainTextField.text {
            Tool.verificationServerURL(serverText, handleSuccess: { (serverURL) -> Void in
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
    
    func showAlertMessage(msg:String, action:ActionHandler){
        let popupVC = CustomPopupViewController(nibName: "CustomPopupViewController", bundle: nil)
        popupVC.descriptionMessage = msg
        popupVC.actionHandler = action
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
}

