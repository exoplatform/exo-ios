//
//  JSConstants.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 6/11/2022.
//  Copyright © 2022 eXo. All rights reserved.
//

import Foundation

enum ScriptType {
    case log
    case warning
    case error
    case debug
}

class JSConstants {
    static let captureLogSource = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
    static let iOSListenerSource = "document.addEventListener('mouseout', function(){ window.webkit.messageHandlers.iosListener.postMessage('iOS Listener executed!'); })"
    static let loggingScript = """
                    function log(type, args) {
                          window.webkit.messageHandlers.logging.postMessage(
                            `JS ${type}: ${Object.values(args)
                              .map(v => typeof(v) === "undefined" ? "undefined" : typeof(v) === "object" ? JSON.stringify(v) : v.toString())
                              .map(v => v.substring(0, 3000)) // Limit msg to 3000 chars
                              .join(", ")}`
                          )
                        }

                        let originalLog = console.log
                        let originalWarn = console.warn
                        let originalError = console.error
                        let originalDebug = console.debug

                        console.log = function() { log("log", arguments); originalLog.apply(null, arguments) }
                        console.warn = function() { log("warning", arguments); originalWarn.apply(null, arguments) }
                        console.error = function() { log("error", arguments); originalError.apply(null, arguments) }
                        console.debug = function() { log("debug", arguments); originalDebug.apply(null, arguments) }

                        window.addEventListener("error", function(e) {
                           log("Uncaught", [`${e.message} at ${e.filename}:${e.lineno}:${e.colno}`])
                        })
                    """
}
