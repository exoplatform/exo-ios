//
//  ActivityCell.swift
//  Stream eXo
//
//  Created by eXo Development on 20/05/2021.
//

import UIKit

class ActivityCell: UITableViewCell {

    static let cellId = "ActivityCell"

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
    
}
