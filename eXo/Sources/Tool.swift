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
            let alertView = UIAlertView.init(title: NSLocalizedString("Server URL error", comment:""), message: NSLocalizedString("Unable to connect the server",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("OK",comment:""))
            alertView.show()
            break
        case ConnectionError.ServerVersionNotFound:
            let alertView = UIAlertView.init(title: NSLocalizedString("Platform version not found", comment:""), message: NSLocalizedString("The application only supports Platform version 4.3 or later",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("OK",comment:""))
            alertView.show()
            break
        case ConnectionError.ServerVersionNotSupport:
            let alertView = UIAlertView.init(title: NSLocalizedString("Platform version not supported", comment:""), message: NSLocalizedString("The application only supports Platform version 4.3 or later",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("OK",comment:""))
            alertView.show()
            break
        default:
            break
        }
    }

    
}