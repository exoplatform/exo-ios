//
//  MyOrderWalletCell.swift
//  eXo
//
//  Created by eXo Development on 04/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class MyOrderWalletCell: UITableViewCell {

    static let cellId = "MyOrderWalletCell"
    
    // MARK: - Outlets.
    
    @IBOutlet weak var ordersLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
      return UINib(nibName: cellId, bundle: nil)
    }
    
    func setDataWith(){
        let attributedStringOrder = NSMutableAttributedString()
        attributedStringOrder.append(text: "0", color: .darkGray, font: UIFont.boldSystemFont(ofSize: 17))
        attributedStringOrder.append(text: " orders".localized, color: .darkGray, font: UIFont.init(name: "Montserrat-Regular", size: 14)!)
        ordersLabel.attributedText = attributedStringOrder
        
        let attributedStringBanlance = NSMutableAttributedString()
        attributedStringBanlance.append(text: "0", color: .darkGray, font: UIFont.boldSystemFont(ofSize: 17))
        attributedStringBanlance.append(text: " C", color: .darkGray, font: UIFont.init(name: "Montserrat-Regular", size: 14)!)
        ordersLabel.attributedText = attributedStringBanlance
    }
}
