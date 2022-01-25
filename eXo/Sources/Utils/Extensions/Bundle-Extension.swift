//
//  Bundle-Extension.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 20/1/2022.
//  Copyright © 2022 eXo. All rights reserved.
//

import Foundation

extension Bundle {

    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

}
