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
import WebKit

class eXoWebBaseController: UIViewController {
    let kRequestTimeout = 10.0 //in seconds
    
    var webView:WKWebView?
    var serverURL:String? // The WebView begin with this link (sent by Server Selection/ Input Server, Basically is the link to platform)
 
    override func viewDidLoad() {        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    Initilalize the WKWebView & setup
    */
    func setupWebView (_ webViewContainer : UIView) {
        let wkWebViewConfiguration = WKWebViewConfiguration()
        // Add configuration to wkwebview relevant to user agent
        wkWebViewConfiguration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        webView = WKWebView (frame:CGRect(x: 0,y: 0,width: webViewContainer.bounds.size.width, height: webViewContainer.bounds.size.height), configuration: wkWebViewConfiguration)        
        //Load the page web
        let url = URL(string: serverURL!)
        // check PLF version and go back if it's less than 4.3
        Tool.getPlatformVersion(url!, success: { (version) -> Void in
            if (version < Config.minimumPlatformVersionSupported) {
                // show warning message from main thread
                OperationQueue.main.addOperation({ () -> Void in
                    self.alertPlatformVersionNotSupported()
                })
            }
        }) { (errorCode) -> Void in
            // failure during the execution of the request, let go...
        }
        // load URL in webview
        let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: kRequestTimeout)//NSURLRequest(URL: url!)
        webView?.load(request)
        webViewContainer.addSubview(webView!)
        
        // disable the autosizing to use manual constraints
        webView?.translatesAutoresizingMaskIntoConstraints = false;
        
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if (webView?.superview != nil) {
            let webViewContainer = webView?.superview!
            // Setup Constraints for WebView. All margin to superview = 0
            webViewContainer?.addConstraint(NSLayoutConstraint(item: webViewContainer!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: webView!, attribute: .top, multiplier: 1.0, constant: 0.0))
            webViewContainer?.addConstraint(NSLayoutConstraint(item: webViewContainer!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: webView!, attribute: .leading, multiplier: 1.0, constant: 0.0))
            webViewContainer?.addConstraint(NSLayoutConstraint(item: webViewContainer!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: webView!, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            webViewContainer?.addConstraint(NSLayoutConstraint(item: webViewContainer!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: webView!, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            
        }
    }
    
    func alertPlatformVersionNotSupported() {
        let alert:UIAlertController = UIAlertController.init(
            title: NSLocalizedString("ServerManager.Title.Warning", comment:""),
            message: NSLocalizedString("ServerManager.Message.WarningVersionNotSupported",comment:""),
            preferredStyle: UIAlertControllerStyle.alert)
        let action:UIAlertAction = UIAlertAction.init(
            title: NSLocalizedString("Word.Back",comment:""),
            style: UIAlertActionStyle.default,
            handler: { (action) -> Void in
                let navigationVC:UINavigationController = self.navigationController!
//                if (navigationVC.viewControllers.count > 1) {
                    // come back to the previous screen
                    navigationVC.popViewController(animated: true)
//                } else {
                    // probably started from the quick action
                    // open the home screen
//                    navigationVC.popToRootViewControllerAnimated(true)
//                }
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
