//
//  UIViewController-Extension.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 20/6/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift

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
    
    func showAlertUpdateVersion(title:String,msg:String){
        let popupVC = CheckUpdatePopupVC(nibName: "CheckUpdatePopupVC", bundle: nil)
        popupVC.titleDescription = title
        popupVC.descriptionMessage = msg
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    
    func showAlertMessage(title:String,msg:String,action:ActionHandler){
        let popupVC = CustomPopupViewController(nibName: "CustomPopupViewController", bundle: nil)
        popupVC.titleDescription = title
        popupVC.descriptionMessage = msg
        popupVC.actionHandler = action
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    
    func showAlertMessageDelete(title:String,msg:String,action:ActionHandler,server:Server){
        let popupVC = CustomPopupViewController(nibName: "CustomPopupViewController", bundle: nil)
        popupVC.titleDescription = title
        popupVC.descriptionMessage = msg
        popupVC.actionHandler = action
        popupVC.serverToDelete = server
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
    
    func getWidth(text: String) -> CGFloat {
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    
    func isInternetConnected(inWeb:Bool) -> Bool {
        if Connectivity.shared.isInternetConnected() {
            return true
        }else{
            self.showAlertGeneralErrorNoNetwork(inWeb:inWeb)
            return false
        }
    }
    
    func checkConnectivity(){
        if !Connectivity.shared.isInternetConnected() {
            self.showAlertGeneralErrorNoNetwork(inWeb:true)
        }
    }
    
    func showAlertGeneralErrorNoNetwork(inWeb:Bool){
        let titleAlert = "Internet connection lost".localized + "\n\n\n\n\n"
        let messageAlert = "\n\n" + "Please make sure you have internet connection".localized + "\n"
        
        let attributedStringTitle = NSAttributedString(string: titleAlert, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x5A8EC7)
        ])
        let attributedStringMessage = NSAttributedString(string: messageAlert, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x5A8EC7)
        ])
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alertController.setValue(attributedStringTitle, forKey: "attributedTitle")
        alertController.setValue(attributedStringMessage, forKey: "attributedMessage")
        alertController.view.tintColor = UIColor(rgb: 0x5A8EC7)
        let imgViewTitle = UIImageView(frame: CGRect(x: 110, y: 80, width: 57, height: 50))
        imgViewTitle.contentMode = .scaleAspectFill
        if #available(iOS 13.0, *) {
            imgViewTitle.image = UIImage(named: "wifi")?.withTintColor(UIColor(rgb: 0xa8b3c5))
        } else {
            imgViewTitle.image = UIImage(named: "wifi")
        }
        alertController.view.addSubview(imgViewTitle)
        let okAction = UIAlertAction(title:"OK".localized, style: UIAlertAction.Style.default) { UIAlertAction in
            if inWeb {
                let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
                appDelegate.setRootOnboarding()
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Send notification while tracking the download status.
    
    func showDownloadBanner(filename:String,status:DownloadStatus) {
        DispatchQueue.main.async {
            var title = ""
            var subtitle = ""
            var style:BannerStyle = .info
            switch status {
            case .completed:
                title = "Download completed"
                subtitle = "\(filename) downloaded successfully"
                style = .success
            case .started:
                title = "Download started"
                subtitle = "The download of \(filename) has been started"
                style = .info
            case .failed:
                title = "Download failed"
                subtitle = "Failed to download the file \(filename)"
                style = .warning
            }
            let banner = FloatingNotificationBanner(title: title, subtitle: subtitle, style: style)
            banner.show(bannerPosition: .top,queue: .default,on:self, cornerRadius: 8,
                        shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                        shadowBlurRadius: 16,
                        shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
        }
    }
}
