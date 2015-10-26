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

class HomePageViewController: UIViewController, WKNavigationDelegate {

    var webView:WKWebView?
    var serverURL:String? // The WebView begin with this link (sent by Server Selection/ Input Server, Basically is the link to platform)
    
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    

    // MARK: View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        loadingIndicator.startAnimating()
    }
    
    /*
    Initilalize the WKWebView & setup
    */
    func setupWebView () {
        let wkWebViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView (frame:CGRectMake(0,0,self.webViewContainer.bounds.size.width,self.webViewContainer.bounds.size.height), configuration: wkWebViewConfiguration)
        webView?.navigationDelegate = self
        
        //Load the page web
        let url = NSURL(string: serverURL!)
        let request = NSURLRequest(URL: url!)
        webView?.loadRequest(request)
        webViewContainer.addSubview(webView!)
        
        // disable the autosizing to use manual constraints
        webView?.translatesAutoresizingMaskIntoConstraints = false;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        /*
        Set the status bar to white color & the navigation bar is always hidden on this screen
        */
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }

    override func updateViewConstraints() {
         super.updateViewConstraints()
        
        // Setup Constraints for WebView. All margin to superview = 0
        webViewContainer?.addConstraint(NSLayoutConstraint(item: webViewContainer, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: webView!, attribute: .Top, multiplier: 1.0, constant: 0.0))
        webViewContainer?.addConstraint(NSLayoutConstraint(item: webViewContainer, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: webView!, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        webViewContainer?.addConstraint(NSLayoutConstraint(item: webViewContainer, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: webView!, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        webViewContainer?.addConstraint(NSLayoutConstraint(item: webViewContainer, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: webView!, attribute: .Trailing, multiplier: 1.0, constant: 0.0))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK : WKWebViewDelegate
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
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let request:NSURLRequest = navigationAction.request
        
        // Detect the logout action in to quit this screen.
        if request.URL?.absoluteString.rangeOfString("portal:action=Logout") != nil  {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        decisionHandler(WKNavigationActionPolicy.Allow)
    }
    
}
