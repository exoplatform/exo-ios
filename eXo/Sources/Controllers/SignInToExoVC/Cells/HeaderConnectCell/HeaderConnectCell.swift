//
//  HeaderConnectCell.swift
//  eXo
//
//  Created by eXo Development on 10/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class HeaderConnectCell: UITableViewCell {

    static let cellId = String(describing: HeaderConnectCell.self)
    
    // MARK: - Outlets.
    
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerTitle.text = NSLocalizedString("OnBoarding.Title.AddNewExo", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: cellId, bundle: nil)
    }
}
