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
    static func verificationServerURL(_ string:String,delegate:UIViewController,handleSuccess: @escaping (_ serverURL:String) ->Void) {
        let serverURL = domainOfStringURL(string)
        let platformInfoURL = serverURL + "/rest/platform/info"
        let url = URL.init(string: platformInfoURL)
        if (url != nil) {
            SVProgressHUD.show(withStatus: NSLocalizedString("OnBoarding.Title.SavingServer", comment:""))
            SVProgressHUD.setDefaultMaskType(.black)
            let operationQueue = OperationQueue.init()
            operationQueue.name = "URLVerification"
            let request = URLRequest.init(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Config.timeout)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                // dismiss the HUD
                OperationQueue.main.addOperation({ () -> Void in
                    SVProgressHUD.popActivity()
                })
                if (error == nil) {
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    if (statusCode >= 200  && statusCode < 300) {
                        // Check platform version
                        do {
                            let json = try JSON(data: data!)
                            if let platformVersion = json["platformVersion"].string {
                                let version = (platformVersion as NSString).floatValue
                                if (version >= Config.minimumPlatformVersionSupported){
                                    handleSuccess(serverURL)
                                } else {
                                    // this application supports only platform version 4.3 or later
                                    Tool.showErrorMessageForCode(delegate: delegate, ConnectionError.ServerVersionNotSupport)
                                }
                            } else {
                                Tool.showErrorMessageForCode(delegate: delegate, ConnectionError.ServerVersionNotFound)
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    } else {
                        Tool.showErrorMessageForCode(delegate: delegate, ConnectionError.URLError)
                    }
                } else {
                    Tool.showErrorMessageForCode(delegate: delegate, ConnectionError.URLError)
                }
            })
            task.resume()
        } else {
            Tool.showErrorMessageForCode(delegate: delegate, ConnectionError.URLError)
        }
    }
    
    static func getPlatformVersion(_ url:URL,delegate:UIViewController,success:@escaping (_ version:Float) -> Void, failure:@escaping (_ errorCode:Int) -> Void) {
        let serverURL = domainOfStringURL(url.absoluteString)
        let platformInfoURL = serverURL + "/rest/platform/info"
        let plfInfoUrl = URL.init(string: platformInfoURL)
        let request = URLRequest.init(url: plfInfoUrl!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Config.timeout)
        let operationQueue = OperationQueue.init()
        operationQueue.name = "PLFVersion"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if (error == nil) {
                do {
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    if (statusCode >= 200  && statusCode < 300) {
                        // Check platform version
                        let json = try JSON(data: data!)
                        if let platformVersion = json["platformVersion"].string {
                            let version = (platformVersion as NSString).floatValue
                            print(version)
                            success(version)
                        } else {
                            failure(ConnectionError.ServerVersionNotFound)
                        }
                    } else {
                        failure(ConnectionError.URLError)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                failure(ConnectionError.URLError)
            }
        })
        task.resume()
    }
    
   
    /*
    Display an error alert corresponse to the error code
    */
    static func showErrorMessageForCode (delegate:UIViewController,_ errorCode : Int) {
        OperationQueue.main.addOperation({ () -> Void in
            switch (errorCode){
            case ConnectionError.URLError :
                showAlertMessage(title: "OnBoarding.Error.URL".localized, msg: "OnBoarding.Error.UnableConnectServer".localized, delegate: delegate, action: .defaultAction)
                break
            case ConnectionError.ServerVersionNotFound:
                showAlertMessage(title: "OnBoarding.Error.PlatformNotFound".localized, msg: "OnBoarding.Error.PlatformNotSupportedDetailMessage".localized, delegate: delegate, action: .defaultAction)
                break
            case ConnectionError.ServerVersionNotSupport:
                showAlertMessage(title: "OnBoarding.Error.PlatformNotSupported".localized, msg: "OnBoarding.Error.PlatformNotSupportedDetailMessage".localized, delegate: delegate, action: .defaultAction)
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
    
   static func showAlertMessage(title:String,msg:String,delegate:UIViewController,action:ActionHandler){
        let popupVC = CustomPopupViewController(nibName: "CustomPopupViewController", bundle: nil)
        popupVC.titleDescription = title
        popupVC.descriptionMessage = msg
        popupVC.actionHandler = action
        popupVC.modalPresentationStyle = .overFullScreen
        delegate.present(popupVC, animated: false, completion: nil)
    }
}
