//
//  UIViewController-Extensions.swift
//  eXo
//
//  Created by eXo Development on 21/04/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    func hideNavBar(){
        navigationController?.navigationBar.isHidden = true
    }
    
    func showNavBar(){
        navigationController?.navigationBar.isHidden = false
    }
    
    func postNotificationWith(key:Notification.Name,info:[AnyHashable:Any]){
        NotificationCenter.default.post(name: key, object: nil, userInfo: info)
    }
    
    func postNotificationWith(key:Notification.Name){
        NotificationCenter.default.post(name: key, object: nil)
    }
    
    func addObserverWith(selector:Selector, name:Notification.Name){
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func removeObserverWith(name:Notification.Name){
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
}
