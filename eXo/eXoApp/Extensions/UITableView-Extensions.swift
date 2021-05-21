//
//  UITableView-Extension.swift
//  eXo
//
//  Created by eXo Development on 04/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func reloadFromMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
