//
//  defines.swift
//  eXoHybrid
//
//  Created by Nguyen Manh Toan on 10/7/15.
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.

import Foundation
import UIKit

struct ShortcutType {
    static let connectRecentServer:String =  "ios.exo.connect-recent-server"
    static let addNewServer:String = "ios.exo.add-new-server"
}

struct Config {
    // eXo Apple Store link
    static let eXoAppleStoreUrl:String = "https://apps.apple.com/us/app/exo/id410476273"
    static let communityURL:String =  "https://community.exoplatform.com"
    static let minimumPlatformVersionSupported:Float = 4.3
    static let maximumShortcutAllow:Int = 4
    static let timeout:TimeInterval = 60.0 // in seconds
    static let onboardingDidShow: String = "onboardingDidShow"
    static let badgePath: String = "/portal/rest/notifications/webNotifications"
    // based on hex code #FFCB08
    static let eXoYellowColor: UIColor = UIColor(red: 255.0/255, green: 203.0/255.0, blue: 8.0/255.0, alpha: 1.0)
    // based on hex code #2F5E92
    static let eXoBlueColor: UIColor = UIColor(red: 68/255, green: 93/255, blue: 147/255, alpha: 1.0)
    
    static let kTableCellHeight: CGFloat = 80.0
    static let kTableHeaderHeight: CGFloat = 50.0
}

struct ShareExtension {
    static let NSUserDefaultSuite:String  = "group.com.exoplatform.mob.eXoPlatformiPHone"
    static let AllUserNameKey:String = "exo_share_all_usernames"
}

enum Cookies: String {
    case username = "last_login_username"
    case domain = "last_login_domain"
    case session = "JSESSIONID"
    case sessionSso = "JSESSIONIDSSO"
    case rememberMe = "rememberme"
}

struct ConnectionError {
    static let URLError = 400
    static let ServerVersionNotSupport = 403
    static let ServerVersionNotFound = 404
}
