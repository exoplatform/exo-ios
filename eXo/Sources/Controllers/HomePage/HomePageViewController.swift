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

class HomePageViewController: eXoWebBaseController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIButton!

    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView(self.webViewContainer)
        webView?.navigationDelegate = self
        webView?.UIDelegate = self
        loadingIndicator.startAnimating()
        self.configureDoneButton()
    }
    
    func configureDoneButton () {
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.borderWidth = 0.5
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        /*
        Set the status bar to white color & the navigation bar is always hidden on this screen
        */
        self.navigationItem.title = NSLocalizedString("OnBoarding.Title.SignInToeXo", comment:"")
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = nil
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func goBackAction(sender: AnyObject) {
        if (webView?.canGoBack == true ) {
            webView?.goBack()
            doneButton.hidden = true
        }
    }
    
    // MARK: WKWebViewDelegate
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        /*
        Disable the Zoom on the Webview
        */
        let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        /*
        Stop loading indicator after finished loading
        */
        loadingIndicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
        loadingIndicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        loadingIndicator.stopAnimating()
        if self.presentedViewController == nil {        
            let alertController = UIAlertController(title: NSLocalizedString("OnBoarding.Error.ConnectionError", comment: ""), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Word.OK", comment: ""), style: UIAlertActionStyle.Cancel) { (cancelAction) -> Void in
            }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: false, completion: nil)
        }

    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        let response:NSURLResponse = navigationResponse.response
        doneButton.hidden = true
        let serverDomain = NSURL(string: self.serverURL!)?.host
        if (response.URL?.absoluteString.rangeOfString(serverDomain!) == nil) {
            decisionHandler(.Cancel)
            
            let previewNavigationController:UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("PreviewNavigationController") as! UINavigationController
            let previewController:PreviewController = previewNavigationController.topViewController as! PreviewController
            previewController.serverURL = response.URL?.absoluteString
            self.presentViewController(previewNavigationController, animated: true, completion: nil)
        } else {
            if response.MIMEType != "text/html" {
                doneButton.hidden = false
            }
            decisionHandler(.Allow)
        }
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let request:NSURLRequest = navigationAction.request
        // Detect the logout action in to quit this screen.
        if request.URL?.absoluteString.rangeOfString("portal:action=Logout") != nil  {
            self.navigationController?.popViewControllerAnimated(true)
        }
        let serverDomain = NSURL(string: self.serverURL!)?.host
        // Display the navigation bar at login or register page && disable the bar when login (register) is finished
        // Home Page Address: portal/intranet/register (hide the navigation bar)
        if request.URL?.absoluteString.rangeOfString(serverDomain!+"/portal/intranet") != nil  {
           self.navigationController?.setNavigationBarHidden(true, animated:true)
        }
        // Page Login Address: [Domain]/portal/login
        // Page Register: [Domain]/portal/intranet/register
        //(show navigation bar when the webview display this pages, because the pages don't contain a embedded navigation bar.
        if (request.URL?.absoluteString.rangeOfString(serverDomain! + "/portal/login") != nil) || (request.URL?.absoluteString.rangeOfString(serverDomain! + "/portal/intranet/register") != nil) {
            self.navigationController?.setNavigationBarHidden(false, animated:true)
        }        
        if !UIApplication.sharedApplication().networkActivityIndicatorVisible {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        }

        decisionHandler(WKNavigationActionPolicy.Allow)
    }
    
    // MARK: WKUIDelegate
    
    // Called when a link opens a new window (target=_blank)
    // We simply reload the request in the existing webview
    // Cf http://stackoverflow.com/a/25853806
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (navigationAction.targetFrame == nil) {
            webView.loadRequest(navigationAction.request)
        }
        return nil
    }
}
