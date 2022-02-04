//
//  CheckUpdatePopupVC.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 2/2/2022.
//  Copyright © 2022 eXo. All rights reserved.
//

import UIKit

class CheckUpdatePopupVC: UIViewController {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pupupTitle: UILabel!
    @IBOutlet weak var updateMessage: UILabel!
    
    var titleDescription = ""
    var descriptionMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        pupupTitle.text = titleDescription
        updateMessage.text = descriptionMessage
        updateButton.addCornerRadiusWith(radius: 5)
        cancelButton.addCornerRadiusWith(radius: 5)
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        let urlStore = Config.eXoAppleStoreUrl
        if let url = URL(string: urlStore) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
