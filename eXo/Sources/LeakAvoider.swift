//
//  LeakAvoider.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 18/4/2022.
//  Copyright © 2022 eXo. All rights reserved.
//

import Foundation
import WebKit

class LeakAvoider : NSObject, WKScriptMessageHandler {
    
    weak var delegate : WKScriptMessageHandler?
    
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(
            userContentController, didReceive: message)
    }
}
