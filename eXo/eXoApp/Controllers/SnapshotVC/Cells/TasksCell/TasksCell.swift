//
//  TasksCell.swift
//  eXo
//
//  Created by eXo Development on 04/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class TasksCell: UITableViewCell {

    static let cellId = "TasksCell"
    
    // MARK: - Outlets.
    
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noTaskLabel: UILabel!
    @IBOutlet weak var placeHolderImage: UIImageView!
    

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
