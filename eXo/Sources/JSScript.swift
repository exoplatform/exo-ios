//
//  JSScript.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 7/11/2022.
//  Copyright © 2022 eXo. All rights reserved.
//

import Foundation

class JSScript {
    static let captureLogSource = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
    static let iOSListenerSource = "document.addEventListener('mouseout', function(){ window.webkit.messageHandlers.iosListener.postMessage('iOS Listener executed!'); })"
    static let responsibleTappingSource = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
    static let closeWindowErrorSource = "[Jitsi] error: Scripts may not close windows that were not opened by script."
}
