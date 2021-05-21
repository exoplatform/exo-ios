//
//  WelcomeBackCell.swift
//  eXo
//
//  Created by eXo Development on 04/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class WelcomeBackCell: UITableViewCell {

    static let cellId = "WelcomeBackCell"

    // MARK: - Outlets.
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var spaceLabel: UILabel!
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var weeklyPointLabel: UILabel!
    @IBOutlet weak var weelklyRankLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    func initView() {
        userImg.makeCircular()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
      return UINib(nibName: cellId, bundle: nil)
    }
}
