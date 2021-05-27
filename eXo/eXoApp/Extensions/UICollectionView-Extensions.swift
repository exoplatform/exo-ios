//
//  UICollectionView-Extensions.swift
//  eXo
//
//  Created by eXo Development on 04/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func reloadFromMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
