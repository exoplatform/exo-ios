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

struct ShortcutType {
    static let connectCommunity:String =  "ios.exo.connect-community"
    static let registerCommunity:String =  "ios.exo.register-community"
    static let connectRecentServer:String =  "ios.exo.connect-recent-server"
}

struct Config {
    static let communityURL:String =  "https://community.exoplatform.com"
    static let supportVersion:Float = 4.3
    static let maximunShortcutAllow:Int = 4
}

struct UserDefaultConfig {
    static let listServerKey:String = "all_servers"
    
}

struct ShareExtension {
    static let NSUserDefaultSuite:String  = "group.com.exoplatform.ios.exo"
    static let AllUserNameKey:String = "exo_share_all_usernames"
}

struct Cookies {
    static let username:String =  "last_login_username"
    static let domain:String =  "last_login_domain"
}


struct ConnectionError {
    static let URLError = 400
    static let ServerVersionNotSupport = 403
    static let ServerVersionNotFound = 404
}
