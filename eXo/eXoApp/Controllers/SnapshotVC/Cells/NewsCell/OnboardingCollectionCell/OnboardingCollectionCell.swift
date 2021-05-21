//
//  OnboardingCollectionCell.swift
//  eXo
//
//  Created by eXo Development on 05/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class OnboardingCollectionCell: UICollectionViewCell {

    static let cellId = "OnboardingCollectionCell"
    
    // MARK: - Outlets.
    
    @IBOutlet weak var onboardingImg: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: cellId, bundle: nil)
    }
}
