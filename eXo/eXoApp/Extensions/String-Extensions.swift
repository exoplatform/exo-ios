//
//  String-Extensions.swift
//  eXo
//
//  Created by eXo Development on 21/04/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func stringURLWithoutProtocol () -> String {
        var stringURLWithoutProtocol = self.replacingOccurrences(of: "http://", with: "")
        stringURLWithoutProtocol = stringURLWithoutProtocol.replacingOccurrences(of: "https://", with: "")
        return stringURLWithoutProtocol
    }
    
    func localized() -> String{
        return NSLocalizedString(self, comment:"")
    }
}
