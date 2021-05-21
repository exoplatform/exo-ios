//
//  NewsCell.swift
//  eXo
//
//  Created by eXo Development on 04/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    static let cellId = "NewsCell"
    
    // MARK: - Outlets.
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var latestNewsLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView() {
        seeAllButton.addCorner()
        seeAllButton.setTitle(Constants.Messages.See_All.localized, for: .normal)
        latestNewsLabel.text = Constants.Messages.Latest_News.localized
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.register(OnboardingCollectionCell.nib(), forCellWithReuseIdentifier: OnboardingCollectionCell.cellId)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
      return UINib(nibName: cellId, bundle: nil)
    }
    
}

extension NewsCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionCell.cellId, for: indexPath) as! OnboardingCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: height)
    }
}
