//
//  CustomPopupViewController.swift
//  IAM
//
//  Created by Wajih Benabdessalem on 2/16/21.
//

import UIKit

enum ActionHandler {
    case defaultAction
    case delete
}

class CustomPopupViewController: UIViewController {
    
    // MARK: - Outlets .

    @IBOutlet weak var containerView: DesignableView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    // MARK: - Variables .

    var descriptionMessage:String = ""
    var titleDescription:String = ""
    var actionHandler:ActionHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        imgView.addCornerRadiusWith(radius: 25)
        okButton.addCornerRadiusWith(radius: 5.0)
        noButton.addBorderWith(width: 1, color: UIColor(hex: 0x4382BF).withAlphaComponent(0.5), cornerRadius: 5.0)
        discriptionLabel.text = descriptionMessage
        titleLabel.text = titleDescription
        switch actionHandler {
        case .delete:
            okButton.setTitle("OnBoarding.Title.DeleteServer".localized, for: .normal)
            noButton.setTitle("OnBoarding.Title.CancelDelete".localized, for: .normal)
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
            switch actionHandler {
            case .delete:
                dismiss(animated: false) {
                    self.postNotificationWith(key: .deleteInstance)
                }
            default:
                self.dismiss(animated:false,completion:nil)
            }
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        self.dismiss(animated:false,completion:nil)
    }
}
