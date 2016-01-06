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
    static func verificationServerURL(string:String, handleSuccess: (serverURL:String) ->Void) {
        
        let serverURL = domainOfStringURL(string)
        
        let platformInfoURL = serverURL + "/rest/platform/info"
        
        let url = NSURL.init(string: platformInfoURL)
        if (url != nil) {
            SVProgressHUD.showWithStatus(NSLocalizedString("OnBoarding.Title.SavingServer", comment:""), maskType: .Black)
            let operationQueue = NSOperationQueue.init()
            operationQueue.name = "URLVerification"
            let request = NSURLRequest.init(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: Config.timeout)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: operationQueue, completionHandler: { (response, data, error) -> Void in
                // dismiss the HUD
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    SVProgressHUD.popActivity()
                })
                
                if (error == nil) {
                    let statusCode = (response as! NSHTTPURLResponse).statusCode
                    if (statusCode >= 200  && statusCode < 300) {
                        // Check platform version
                        let json = JSON(data: data!)
                        if let platformVersion = json["platformVersion"].string {
                            let version = (platformVersion as NSString).floatValue
                            if (version >= Config.minimumPlatformVersionSupported){
                                handleSuccess(serverURL: serverURL)
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
    /*
    Display an error alert corresponse to the error code
    */
    static func showErrorMessageForCode (errorCode : Int) {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            switch (errorCode){
            case ConnectionError.URLError :
                let alertView = UIAlertView.init(title: NSLocalizedString("OnBoarding.Error.URL", comment:""), message: NSLocalizedString("OnBoarding.Error.UnableConnectServer",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("Word.OK",comment:""))
                alertView.show()
                break
            case ConnectionError.ServerVersionNotFound:
                let alertView = UIAlertView.init(title: NSLocalizedString("OnBoarding.Error.PlatformNotFound", comment:""), message: NSLocalizedString("OnBoarding.Error.PlatformNotSupportedDetailMessage",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("Word.OK",comment:""))
                alertView.show()
                break
            case ConnectionError.ServerVersionNotSupport:
                let alertView = UIAlertView.init(title: NSLocalizedString("OnBoarding.Error.PlatformNotSupported", comment:""), message: NSLocalizedString("OnBoarding.Error.PlatformNotSupportedDetailMessage",comment:""), delegate: nil, cancelButtonTitle: NSLocalizedString("Word.OK",comment:""))
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
    static func domainOfStringURL(theURL: String) -> String {
        
        //Add a protocol for the user's input URL if not exist. The default protocol is http://
        var urlWithProtocol = theURL
        if ( urlWithProtocol.rangeOfString("http://") == nil && urlWithProtocol.rangeOfString("https://") == nil ) {
            urlWithProtocol = "http://" + urlWithProtocol
        }
        // make a NSURL with this protocol
        let url = NSURL(string: urlWithProtocol)
        if (url != nil) {
            if (url?.host != nil) {
                var domain = (url?.scheme)! + "://" + (url?.host)!
                // check if URL contains a port.
                if (url?.port != nil){
                    let port:Int! = url?.port?.integerValue
                    domain += ":\(port)"
                }
                return domain
            }
        }
        
        // in case of unable to create the url, just return the origin URL with protocol
       
        return urlWithProtocol
    }
    /*
    Configure the layer of a normal view to border (radius 5.0), use this frequently for the buttons
    */
    static func applyBorderForView (view:UIView) {
        applyBorderForView(view, cornerRadius: 5.0, borderWidth: 0.0, borderColor: UIColor.lightGrayColor())
    }
    
    static func applyBlueBorderForView (view:UIView) {
        applyBorderForView(view, cornerRadius: 5.0, borderWidth: 0.0, borderColor: Config.eXoBlueColor)
    }
    
    static func applyBorderForView (view:UIView, cornerRadius:CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.CGColor
    }
}