//
//  NotificationName-Extension.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 20/6/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let addDomainKey = Notification.Name(rawValue: "AddDomainKey")
    public static let deleteInstance = Notification.Name(rawValue: "deleteInstance")
    public static let rootFromScanURL = Notification.Name(rawValue: "rootFromScanURL")
}
