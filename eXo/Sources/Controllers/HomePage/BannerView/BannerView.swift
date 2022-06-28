//
//  BannerView.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 27/6/2022.
//  Copyright © 2022 eXo. All rights reserved.
//

import UIKit

class BannerView: UITableViewCell {
    
    static let viewId = String(describing: BannerView.self)
    
    @IBOutlet weak var bannerTitleLbl: UILabel!
    
    @IBOutlet weak var bannerSubtitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: viewId, bundle: nil)
    }
}
