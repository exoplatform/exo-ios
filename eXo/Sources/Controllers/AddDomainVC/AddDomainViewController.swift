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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        domainTextField.delegate = self
        textViewContainer.addBorderWith(width: 1, color: .lightGray, cornerRadius: 6)
        let attributedStringFormule = NSMutableAttributedString()
        attributedStringFormule.append(text: "company.", color: .lightGray, font: UIFont.init(name: "HelveticaNeue-Medium", size: 17)!)
        attributedStringFormule.append(text: "exoplatform.com", color: .darkGray, font: UIFont.init(name: "HelveticaNeue-Medium", size: 17)!)
        domainTextField.attributedText = attributedStringFormule
        domainTextField.clearButtonMode = .always
    }
    
    @IBAction func cleseButtonTappee(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
    func showAlertMessage(msg:String, action:ActionHandler){
        let popupVC = CustomPopupViewController(nibName: "CustomPopupViewController", bundle: nil)
        popupVC.descriptionMessage = msg
        popupVC.actionHandler = action
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
}

extension NSMutableAttributedString {
    func append(text:String,color:UIColor,font:UIFont){
        let attributeText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.font:font])
        self.append(attributeText)
    }
}
