//
//  AgendaCell.swift
//  eXo
//
//  Created by eXo Development on 04/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class AgendaCell: UITableViewCell {

    static let cellId = "AgendaCell"
    
    // MARK: - Outlets.
    
    @IBOutlet weak var agendaLabel: UILabel!
    @IBOutlet weak var timeImg: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    

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
