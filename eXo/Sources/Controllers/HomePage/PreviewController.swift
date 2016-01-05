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

class PreviewController: eXoWebBaseController, WKNavigationDelegate {
    
    // Navigation buttons of the webView
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    
    // MARK: View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView(self.view)
        webView?.navigationDelegate = self
        goBackButton.enabled = false
        goForwardButton.enabled = false
    }
    
    // MARK: Navigation Action: Close, GoBack, GoForward
    
    @IBAction func doneAction(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func goBackAction(sender: AnyObject) {
        if (webView != nil && webView?.canGoBack == true) {
            webView?.goBack()
        }
    }
    
    @IBAction func forwardAction(sender: AnyObject) {
        if (webView != nil && webView?.canGoForward == true) {
            webView?.goForward()
        }
    }
    
    
    // MARK : WKWebViewDelegate
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.updateNavigationStatus()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        self.updateNavigationStatus()
        if !UIApplication.sharedApplication().networkActivityIndicatorVisible {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        }
        decisionHandler(.Allow)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        self.updateNavigationStatus()
        decisionHandler(WKNavigationResponsePolicy.Allow)
    }
    
    func updateNavigationStatus () {
        self.navigationItem.title  = webView!.title
        goBackButton.enabled = webView!.canGoBack
        goForwardButton.enabled = webView!.canGoForward

    }
    
    
}