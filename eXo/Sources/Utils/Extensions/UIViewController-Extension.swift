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
    
    func showDownloadBanner(_ filename:String,_ status:DownloadStatus) {
        var bannerTitle = ""
        var bannerSubtitle = ""
        var bannerColor = UIColor(hex: 0x52C7FF)
        switch status {
        case .completed:
            bannerTitle = "Download completed".localized
            bannerSubtitle = "\(filename) downloaded successfully".localized
            bannerColor = UIColor(hex: 0x08cc2c)
        case .started:
            bannerTitle = "Download started"
            bannerSubtitle = "The download of \(filename) has been started".localized
            bannerColor = UIColor(hex: 0x52C7FF)
        case .failed:
            bannerTitle = "Download failed"
            bannerSubtitle = "Failed to download the file \(filename)".localized
            bannerColor = UIColor(hex: 0xc76e26)
        }
        DispatchQueue.main.async {
            let bannerView = BannerView.nib().instantiate(withOwner: self, options: nil).first as! BannerView
            bannerView.contentView.addCornerRadiusWith(radius: 10)
            bannerView.makeShadowWith(offset: CGSize(width: -10,height: 10), radius: 5, opacity: 0.3, color: .black)
            bannerView.bannerTitleLbl.text = bannerTitle
            bannerView.bannerSubtitleLbl.text = bannerSubtitle
            bannerView.contentView.backgroundColor = bannerColor
            self.view.addSubview(bannerView)
            let widthScreen = UIScreen.main.bounds.width
            let widthBV = bannerView.frame.size.width
            let heightBV = bannerView.frame.size.height
            let originBannerX = widthScreen/2 - widthBV/2
            let originBannerY = UIApplication.shared.statusBarFrame.height + 10
            bannerView.frame.origin.x = originBannerX
            bannerView.frame.origin.y = -originBannerY - heightBV
            bannerView.alpha = 0.5
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                bannerView.alpha = 1
                bannerView.frame.origin.y = originBannerY
            }) { _ in
                UIView.animate(withDuration: 1,delay: 4) {
                    bannerView.alpha = 0.5
                    bannerView.frame.origin.y = -originBannerY - heightBV
                } completion: { _ in
                    bannerView.removeFromSuperview()
                }
            }
        }
    }
}
