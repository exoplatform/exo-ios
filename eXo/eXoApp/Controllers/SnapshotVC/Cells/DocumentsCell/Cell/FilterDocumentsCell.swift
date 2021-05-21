//
//  FilterDocumentsCell.swift
//  eXo
//
//  Created by eXo Development on 17/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class FilterDocumentsCell: UICollectionViewCell {
    
    static let cellId = "FilterDocumentsCell"

    // MARK: - Outlets.
    
    @IBOutlet weak var filterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
      return UINib(nibName: cellId, bundle: nil)
    }
    
    func setDataWith(filter:String){
        filterLabel.text = filter
    }
    
}
