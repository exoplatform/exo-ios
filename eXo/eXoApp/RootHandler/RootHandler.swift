//
//  RootHandler.swift
//  eXo
//
//  Created by eXo Development on 22/04/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

enum RootVC {
    
    case snapshotVC
   // case streamVC

    var viewController: UIViewController {
        switch self {
        case .snapshotVC: return SnapshotViewController()
       // case .streamVC: return StreamViewController()
        }
    }
}
