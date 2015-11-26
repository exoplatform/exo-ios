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
        Tool.applyBorderForView(doneButton)
        doneButton.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = nil
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBarHidden = false
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
        
        //Check if need to display the welcome view
        if (NSUserDefaults.standardUserDefaults().objectForKey(Config.onboardingDidShow) == nil){
            loadStateStatusPage ()
        }

    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
        loadingIndicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        let response:NSHTTPURLResponse = navigationResponse.response as! NSHTTPURLResponse
        doneButton.hidden = true
        let serverDomain = NSURL(string: self.serverURL!)?.host
        
        /*
        Request to /rest/state/status to check if user has connected?: 300> status code >=200 --> Connected
        */
        if response.URL?.absoluteString.rangeOfString(serverDomain!+"/rest/state/status") != nil  {
            if (response.statusCode >= 200  && response.statusCode < 300) {
                self.showOnBoardingIfNeed()
            }
            decisionHandler(.Cancel)
            return
        }
        
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
    
    /*
    Display the Onboarding View Controller if:
    - The view has never been shown
    - After use has logged in
    */
    func showOnBoardingIfNeed () {
        if (NSUserDefaults.standardUserDefaults().objectForKey(Config.onboardingDidShow) == nil){
            let welcomeVC:WelcomeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WelcomeViewController") as! WelcomeViewController
            welcomeVC.modalPresentationStyle = UIModalPresentationStyle.FullScreen
            welcomeVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.presentViewController(welcomeVC, animated: true, completion: {})
            NSUserDefaults.standardUserDefaults().setObject(NSNumber(bool: true), forKey: Config.onboardingDidShow)
        }
    }
    
    /*
    Ask to load the page <serverURL>/rest/state/status 
    - If the user has connected the response status code of this request = 200
    */
    func loadStateStatusPage () {
        let serverDomain = NSURL(string: self.serverURL!)?.host
        if self.webView?.URL!.absoluteString.rangeOfString(serverDomain!+"/portal/intranet") != nil  {
            let statusURL = self.serverDomainWithProtocolAndPort() + "/rest/state/status"
            let url = NSURL(string: statusURL)
            let request = NSURLRequest(URL: url!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: Config.timeout)
            self.webView?.loadRequest(request)
            
        }
    }
    
    /*
    Return the serverURL with protocol & port (if need)
    example: serverURL = http://localhost:8080/portal/intranet 
    -> full domain with protocol & port = http://localhost:8080
    */
    func serverDomainWithProtocolAndPort () -> String {
        let url = NSURL(string: self.serverURL!)
        var fullDomain = url!.scheme + "://" + url!.host!
        if (url!.port != nil) {
            fullDomain += ":\(url!.port)"
        }
        return fullDomain

    }
}
