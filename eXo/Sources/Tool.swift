//
//  Tool.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/20/15.
//  Copyright © 2015 eXo. All rights reserved.
//

import UIKit

class Tool {
    // MARK: - Tool
    static func showErrorMessageForCode (errorCode : Int) {
        switch (errorCode){
        case ConnectionError.URLError :
            let alertView = UIAlertView.init(title: NSLocalizedString("OnBoarding.Error.URL", comment:""), message: NSLocalizedString("OnBoarding.Error.UnableConnectServer",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("Word.OK",comment:""))
            alertView.show()
            break
        case ConnectionError.ServerVersionNotFound:
            let alertView = UIAlertView.init(title: NSLocalizedString("OnBoarding.Error.PlatformNotFound", comment:""), message: NSLocalizedString("OnBoarding.Error.PlatformNotSupportedDetailMessage",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("Word.OK",comment:""))
            alertView.show()
            break
        case ConnectionError.ServerVersionNotSupport:
            let alertView = UIAlertView.init(title: NSLocalizedString("OnBoarding.Error.PlatformNotSupported", comment:""), message: NSLocalizedString("OnBoarding.Error.PlatformNotSupportedDetailMessage",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("Word.OK",comment:""))
            alertView.show()
            break
        default:
            break
        }
    }
    
    static func applyBorderForView (view:UIView) {
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
}