//
//  Connectivity.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 16/7/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
class Connectivity {

    static let shared = Connectivity()
    private init () {}

    func isInternetConnected() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            }
        }
        catch {
            return false
        }
    }
}
