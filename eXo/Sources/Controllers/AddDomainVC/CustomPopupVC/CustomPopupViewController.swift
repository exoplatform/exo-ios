//
//  CustomPopupViewController.swift
//  IAM
//
//  Created by Wajih Benabdessalem on 2/16/21.
//

import UIKit

enum ActionHandler {
    case defaultAction
    case sessionExpired
    case update
    case logout
}

class CustomPopupViewController: UIViewController {

    @IBOutlet weak var containerView: DesignableView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var descriptionMessage:String = ""
    var actionHandler:ActionHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        imgView.addCornerRadiusWith(radius: 25)
        okButton.addCornerRadiusWith(radius: 5.0)
        noButton.addBorderWith(width: 1, color: UIColor(hex: 0xE96614), cornerRadius: 5.0)
        discriptionLabel.text = descriptionMessage
        switch actionHandler {
        case .logout:
            okButton.setTitle("Yes".localized, for: .normal)
            noButton.setTitle("No".localized, for: .normal)
            noButton.isHidden = false
            noButton.isEnabled = true
        case .update:
            okButton.setTitle("Update".localized, for: .normal)
            noButton.setTitle("Cancel".localized, for: .normal)
            noButton.isHidden = false
            noButton.isEnabled = true
        default:
            okButton.frame.origin.x = containerView.frame.size.width/2 - okButton.frame.size.width/2
            noButton.isHidden = true
            noButton.isEnabled = false
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissPopup(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissPopup(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        self.dismiss(animated:false,completion:nil)
    }

}
