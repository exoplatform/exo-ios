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


struct Config {
    static let communityURL:String =  "https://community.exoplatform.org"
    static let supportVersion:Float = 4.3
}

struct UserDefaultConfig {
    static let listServerKey:String = "all_servers"
    
}

struct ShareExtension {

}

struct Cookies {
    static let username:String =  "last_login_username"
    static let domain:String =  "last_login_username"    
}
