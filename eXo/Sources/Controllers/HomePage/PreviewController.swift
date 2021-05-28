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

class PreviewController: eXoWebBaseController, WKNavigationDelegate, WKUIDelegate  {
    
    // Navigation buttons of the webView
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    var isStatusBarHidden = true{
         didSet{
             self.setNeedsStatusBarAppearanceUpdate()
         }
     }
    // MARK: View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView(self.view)
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        goBackButton.isEnabled = false
        goForwardButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isStatusBarHidden = true
    }
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isStatusBarHidden = false
    }
    
    // MARK: Navigation Action: Close, GoBack, GoForward
    
    @IBAction func doneAction(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackAction(_ sender: AnyObject) {
        if (webView != nil && webView?.canGoBack == true) {
            webView?.goBack()
        }
    }
    
    @IBAction func forwardAction(_ sender: AnyObject) {
        if (webView != nil && webView?.canGoForward == true) {
            webView?.goForward()
        }
    }
    
    
    // MARK : WKWebViewDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.updateNavigationStatus()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.updateNavigationStatus()
        if !UIApplication.shared.isNetworkActivityIndicatorVisible {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
        self.updateNavigationStatus()
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    func updateNavigationStatus () {
        self.navigationItem.title  = webView!.title
        goBackButton.isEnabled = webView!.canGoBack
        goForwardButton.isEnabled = webView!.canGoForward

    }
    
    
}
