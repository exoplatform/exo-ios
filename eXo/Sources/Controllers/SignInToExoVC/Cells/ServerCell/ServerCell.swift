//
//  ServerCell.swift
//  eXo
//
//  Created by eXo Development on 10/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class ServerCell: UITableViewCell {

    static let cellId = String(describing: ServerCell.self)
    
    // MARK: - Outlets.
    
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initView(){
        badgeView.makeCircular()
        containerView.makeShadowWith(offset: CGSize(width: 5, height: 5), radius: 6, opacity: 0.1, color: .darkGray)
        containerView.addCornerRadiusWith(radius: 6)
        containerView.addBorderWith(width:1,color: UIColor.lightGray.withAlphaComponent(0.5))
    }
    
    static func nib() -> UINib {
        return UINib(nibName: cellId, bundle: nil)
    }
    
    func setupDataWith(){
        
    }
}
