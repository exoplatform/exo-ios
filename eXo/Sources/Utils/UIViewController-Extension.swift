//
//  UIViewController-Extension.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 20/6/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func postNotificationWith(key:Notification.Name,info:[AnyHashable:Any]){
        NotificationCenter.default.post(name: key, object: nil, userInfo: info)
    }
    
    func postNotificationWith(key:Notification.Name){
        NotificationCenter.default.post(name: key, object: nil)
    }
    
    func addObserverWith(selector:Selector, name:Notification.Name){
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func goBack(){
        navigationController?.popViewController(animated: true)
    }
}
