//
//  ServerCell.swift
//  eXo
//
//  Created by eXo Development on 10/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit
import Kingfisher

import UIKit

class ServerCell: UITableViewCell {

    // MARK: - Cell ID .
    
    static let cellId = String(describing: ServerCell.self)
    
    // MARK: - Outlets.
    
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initView(){
        badgeView.makeCircular()
        containerView.addBorderWith(width:1,color: UIColor.lightGray.withAlphaComponent(0.5), cornerRadius: 6)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: cellId, bundle: nil)
    }
    
    func setupDataWith(serveur:String){
        serverLabel.text = serveur
        if let data = UserDefaults.standard.data(forKey: serveur) {
            self.avatarImgView.image = UIImage(data: data)
        }
    }
}

