// Copyright (C) 2003-2015 eXo Platform SAS.
//
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

import UIKit
import SVProgressHUD
import SwiftyJSON

class Tool {
    
    // MARK: - Tool
    
    /*
    - Check the input text enter by user, verify if the URL is valid & the version of the platform is satisfied
    - Display a alert in case of an error occur
    - Return the valid ServerURL via a bloc (handleSuccess)
    */
    static func verificationServerURL(_ string:String, handleSuccess: @escaping (_ serverURL:String) ->Void) {
        
        let serverURL = domainOfStringURL(string)
        
        let platformInfoURL = serverURL + "/rest/platform/info"
        
        let url = URL.init(string: platformInfoURL)
        if (url != nil) {
            SVProgressHUD.show(withStatus: "OnBoarding.Title.SavingServer".localized(), maskType: .black)
            let operationQueue = OperationQueue.init()
            operationQueue.name = "URLVerification"
            let request = URLRequest.init(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Config.timeout)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: operationQueue, completionHandler: { (response, data, error) -> Void in
                // dismiss the HUD
                OperationQueue.main.addOperation({ () -> Void in
                    SVProgressHUD.popActivity()
                })
                
                if (error == nil) {
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    if (statusCode >= 200  && statusCode < 300) {
                        // Check platform version
                        let json = JSON(data: data!)
                        if let platformVersion = json["platformVersion"].string {
                            let version = (platformVersion as NSString).floatValue
                            if (version >= Config.minimumPlatformVersionSupported){
                                handleSuccess(serverURL)
                            } else {
                                // this application supports only platform version 4.3 or later
                                Tool.showErrorMessageForCode(ConnectionError.ServerVersionNotSupport)
                            }
                        } else {
                            Tool.showErrorMessageForCode(ConnectionError.ServerVersionNotFound)
                        }
                        
                    } else {
                        Tool.showErrorMessageForCode(ConnectionError.URLError)
                    }
                } else {
                    Tool.showErrorMessageForCode(ConnectionError.URLError)
                }
            })
        } else {
            Tool.showErrorMessageForCode(ConnectionError.URLError)
        }

    }
    
    static func getPlatformVersion(_ url:URL, success:@escaping (_ version:Float) -> Void, failure:@escaping (_ errorCode:Int) -> Void) {
        
        let serverURL = domainOfStringURL(url.absoluteString)
        
        let platformInfoURL = serverURL + "/rest/platform/info"
        
        let plfInfoUrl = URL.init(string: platformInfoURL)
        
        let request = URLRequest.init(url: plfInfoUrl!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Config.timeout)
        let operationQueue = OperationQueue.init()
        operationQueue.name = "PLFVersion"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: operationQueue) { (response, data, error) -> Void in
            if (error == nil) {
                let statusCode = (response as! HTTPURLResponse).statusCode
                if (statusCode >= 200  && statusCode < 300) {
                    // Check platform version
                    let json = JSON(data: data!)
                    if let platformVersion = json["platformVersion"].string {
                        let version = (platformVersion as NSString).floatValue
                        success(version)
                    } else {
                        failure(ConnectionError.ServerVersionNotFound)
                    }
                } else {
                    failure(ConnectionError.URLError)
                }
            } else {
                failure(ConnectionError.URLError)
            }
        }
    }
    
   
    /*
    Display an error alert corresponse to the error code
    */
    static func showErrorMessageForCode (_ errorCode : Int) {
        OperationQueue.main.addOperation({ () -> Void in
            switch (errorCode){
            case ConnectionError.URLError :
                let alertView = UIAlertView.init(title: "OnBoarding.Error.URL".localized(), message: "OnBoarding.Error.UnableConnectServer".localized(), delegate: nil, cancelButtonTitle: "Word.OK".localized())
                alertView.show()
                break
            case ConnectionError.ServerVersionNotFound:
                let alertView = UIAlertView.init(title: "OnBoarding.Error.PlatformNotFound".localized(), message: "OnBoarding.Error.PlatformNotSupportedDetailMessage".localized(), delegate: nil, cancelButtonTitle: "Word.OK".localized())
                alertView.show()
                break
            case ConnectionError.ServerVersionNotSupport:
                let alertView = UIAlertView.init(title: "OnBoarding.Error.PlatformNotSupported".localized(), message: "OnBoarding.Error.PlatformNotSupportedDetailMessage".localized(), delegate: nil, cancelButtonTitle: "Word.OK".localized())
                alertView.show()
                break
            default:
                break
            }
        })
    }
    
    /*
    The the scheme & host part with port (if exist) of a URL enter by user to
    */
    static func domainOfStringURL(_ theURL: String) -> String {
        
        //Add a protocol for the user's input URL if not exist. The default protocol is http://
        var urlWithProtocol = theURL
        if ( urlWithProtocol.range(of: "http://") == nil && urlWithProtocol.range(of: "https://") == nil ) {
            urlWithProtocol = "http://" + urlWithProtocol
        }
        // make a NSURL with this protocol
        let url = URL(string: urlWithProtocol)
        if (url != nil) {
            if (url?.host != nil) {
                var domain = (url?.scheme)! + "://" + (url?.host)!
                // check if URL contains a port.
                if ((url as NSURL?)?.port != nil){
                    let port:Int! = (url as NSURL?)?.port?.intValue
                    domain += ":\(port)"
                }
                return domain
            }
        }
        
        // in case of unable to create the url, just return the origin URL with protocol
       
        return urlWithProtocol
    }
    
    /**
     Extract a normalized server url from a string containing an url
    */
    static func extractServerUrl (sourceUrl: String) -> String {
        var extractedUrl = sourceUrl.lowercased()
        let range = NSRange(location: 0, length: extractedUrl.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^https?:.*$")
        if (regex.numberOfMatches(in: extractedUrl, range: range) == 0) {
            extractedUrl = "http://"+extractedUrl
        }
        
        var url:URLComponents = URLComponents(string: extractedUrl)!
        
        var computedUrl:String = url.host!
        
        if (url.scheme == nil) {
            switch url.port {
            case 80: computedUrl="http://" + computedUrl
            case 443: computedUrl="https://" + computedUrl
            default:computedUrl="http://" + computedUrl
            }
        } else {
            computedUrl = url.scheme! + "://" + computedUrl
        }
        
        switch url.port {
        case 80: computedUrl=computedUrl+""
        case 443: computedUrl=computedUrl+""
        case nil: computedUrl=computedUrl+""
        default: computedUrl=computedUrl + ":" + String(url.port!)
        }
        
        extractedUrl = computedUrl
        
        return extractedUrl
    }
    
    /*
    Configure the layer of a normal view to border (radius 5.0), use this frequently for the buttons
    */
    static func applyBorderForView (_ view:UIView) {
        applyBorderForView(view, cornerRadius: 5.0, borderWidth: 0.0, borderColor: UIColor.lightGray)
    }
    
    static func applyBlueBorderForView (_ view:UIView) {
        applyBorderForView(view, cornerRadius: 5.0, borderWidth: 0.0, borderColor: Config.eXoBlueColor)
    }
    
    static func applyBorderForView (_ view:UIView, cornerRadius:CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
    }
}
