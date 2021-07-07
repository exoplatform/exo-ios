//
//  OnboardingCell.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 5/7/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    static let cellId = String(describing: OnboardingCell.self)
    
    // MARK: - Outlets .
    
    @IBOutlet weak var onboardingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: cellId, bundle: nil)
    }
    
    func setDataWith(slide:OnboardingItem) {
        onboardingImage.image = UIImage(named: slide.image)
    }
}

struct OnboardingItem {
    var title:String?
    var image:String!
}
