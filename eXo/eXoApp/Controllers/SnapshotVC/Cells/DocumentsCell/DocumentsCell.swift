//
//  DocumentsCell.swift
//  eXo
//
//  Created by eXo Development on 04/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class DocumentsCell: UITableViewCell {

    static let cellId = "DocumentsCell"
    
    // MARK: - Outlets.
    
    @IBOutlet weak var documentLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initView() {
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(FilterDocumentsCell.nib(), forCellWithReuseIdentifier: FilterDocumentsCell.cellId)
    }
    
    static func nib() -> UINib {
      return UINib(nibName: cellId, bundle: nil)
    }
    
}

extension DocumentsCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterDocumentsCell.cellId, for: indexPath) as! FilterDocumentsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width/4
        return CGSize(width: width, height: height)
    }
    
}
