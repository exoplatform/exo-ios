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
    case store
}

class CustomPopupViewController: UIViewController {
    
    // MARK: - Outlets .
    
    @IBOutlet weak var containerView: DesignableView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Variables .
    
    var descriptionMessage:String = ""
    var titleDescription:String = ""
    var actionHandler:ActionHandler!
    var serverToDelete:Server!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        okButton.addCornerRadiusWith(radius: 5.0)
        noButton.addBorderWith(width: 1, color: UIColor(hex: 0x4382BF).withAlphaComponent(0.5), cornerRadius: 5.0)
        discriptionLabel.text = descriptionMessage
        titleLabel.text = titleDescription
        switch actionHandler {
        case .delete:
            let okButtonTitle = "Delete".localized
            let noButtonTitle = "Cancel".localized
            okButton.setTitle(okButtonTitle, for: .normal)
            noButton.setTitle(noButtonTitle, for: .normal)
            noButton.isHidden = false
            noButton.isEnabled = true
        case .store:
            let okButtonTitle = "Install".localized
            let noButtonTitle = "Cancel".localized
            okButton.setTitle(okButtonTitle, for: .normal)
            noButton.setTitle(noButtonTitle, for: .normal)
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
                ServerManager.sharedInstance.removeServer(self.serverToDelete)
                self.postNotificationWith(key: .deleteInstance)
            }
        case .store:
            dismiss(animated: false) {
                if let url = URL(string: "itms-apps://itunes.apple.com/app/id1165103905") {
                    UIApplication.shared.open(url)
                }
            }
        default:
            self.dismiss(animated:false,completion:nil)
        }
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        self.dismiss(animated:false,completion:nil)
    }
}
