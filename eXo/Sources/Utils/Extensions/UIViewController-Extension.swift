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
    
    func showAlertMessage(title:String,msg:String,action:ActionHandler){
        let popupVC = CustomPopupViewController(nibName: "CustomPopupViewController", bundle: nil)
        popupVC.titleDescription = title
        popupVC.descriptionMessage = msg
        popupVC.actionHandler = action
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    
    func isValidURL(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
