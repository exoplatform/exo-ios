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
    
    var parentVC:UIViewController{
        return self.parent!.parent!
    }
    
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
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return defaultMenuImage;
    }
    
    func push(to:UIViewController){
        self.navigationController?.pushViewController(to, animated: true)
    }

    func push(to:RootVC){
        self.navigationController?.pushViewController(to.viewController, animated: true)
    }

    func present(vc:UIViewController,style:UIModalPresentationStyle){
        vc.modalPresentationStyle = style
        self.present(vc, animated: false, completion: nil)
    }

}

