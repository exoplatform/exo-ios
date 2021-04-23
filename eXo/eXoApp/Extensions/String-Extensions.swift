//
//  String-Extensions.swift
//  eXo
//
//  Created by eXo Development on 21/04/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation

extension String {
   
    //Remove the protocol (http:// or https://) of a URL in string
    func stringURLWithoutProtocol () -> String {
        var stringURLWithoutProtocol = self.replacingOccurrences(of: "http://", with: "")
        stringURLWithoutProtocol = stringURLWithoutProtocol.replacingOccurrences(of: "https://", with: "")
        return stringURLWithoutProtocol
    }
}
