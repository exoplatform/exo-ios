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
import Kingfisher
import AVFoundation

class HomePageViewController: eXoWebBaseController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIButton!
    
    private let cookiesInterceptor: CookiesInterceptor = CookiesInterceptorFactory().create()
    private let cookiesFromAuthFetcher = CookiesFromAuthorizationFetcher()
    
    let defaults = UserDefaults.standard
    
    var countRefresh:Int = 0
    var dic:Dictionary = [String:Bool]()
    var player: AVAudioPlayer?

    private var popupWebView: WKWebView?

    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PushTokenSynchronizer.shared.isSessionExpired(delegate:self, inWeb: true) {
            let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
            appDelegate.handleRootConnect()
        }else{
            self.setupWebView(self.webViewContainer)
            webView?.navigationDelegate = self
            webView?.uiDelegate = self
            webView?.configuration.preferences.javaScriptEnabled = true
            webView?.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
            // inject JS to capture console.log output and send to iOS
            let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
            let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView?.configuration.userContentController.addUserScript(script)
            // register the bridge script that listens for the output
            webView?.configuration.userContentController.add(self, name: "logHandler")
            self.configureDoneButton()
        }
    }
    
    func configureDoneButton () {
        Tool.applyBorderForView(doneButton)
        doneButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
         Set the status bar to white color & the navigation bar is always hidden on this screen
         */
        navigationController?.navigationBar.isHidden = false
        setNavigationBarAppearance()
        if self.defaults.bool(forKey: "isLoggedIn") {
            self.navigationController?.setNavigationBarHidden(true, animated:false)
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated:false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBarAppearance()
    }
    
    func setNavigationBarAppearance(){
        self.navigationItem.title = NSLocalizedString("OnBoarding.Title.SignInToeXo", comment:"")
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0xF0F0F0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        //MARK:- menuButton
        let menuButton = UIButton(type: .system)
        menuButton.setBackgroundImage(UIImage(named: "goBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        menuButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        menuButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        let rightBarButtonItem3 = UIBarButtonItem()
        rightBarButtonItem3.customView = menuButton
        navigationItem.setLeftBarButtonItems([rightBarButtonItem3], animated: true)
    }
    
    @objc func popVC(){
        let countVC = self.navigationController?.viewControllers.count
        if countVC == 1 {
            if ServerManager.sharedInstance.serverList.count == 0 {
                let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
                appDelegate.setRootOnboarding()
            }else{
                let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
                appDelegate.handleRootConnect()
            }
        }else{
            let vcs: [UIViewController] = self.navigationController!.viewControllers
            if vcs.contains(ConnectToExoViewController()){
                for vc in vcs {
                    if vc is ConnectToExoViewController {
                        self.navigationController!.popToViewController(vc, animated: true)
                    }
                }
            }else{
                if ServerManager.sharedInstance.serverList.count == 0 {
                    let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
                    appDelegate.setRootOnboarding()
                }else{
                    let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
                    appDelegate.handleRootConnect()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Actions
    
    @IBAction func goBackAction(_ sender: AnyObject) {
        if (webView?.canGoBack == true ) {
            webView?.goBack()
            doneButton.isHidden = true
        }
    }
    
    // MARK: WKWebViewDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        /*
         Disable the Zoom on the Webview & more responsible tapping
         https://webkit.org/blog/5610/more-responsive-tapping-on-ios/
         */
        let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /*
         Stop loading indicator after finished loading
         */
        loadingIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
        
        //Check if need to display the welcome view
        if (self.defaults.object(forKey: Config.onboardingDidShow) == nil){
            loadStateStatusPage()
        }
        
        if let urlToSee = webView.url?.absoluteString {
            print("=============== didFinish Url : \(urlToSee)")
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        loadingIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        checkConnectivity()
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
        let response:HTTPURLResponse = navigationResponse.response as! HTTPURLResponse
        doneButton.isHidden = true
        let serverDomain = URL(string: self.serverURL!)?.host
        
        /*
         Request to /rest/state/status to check if user has connected?: 300> status code >=200 --> Connected
         */
        if response.url?.absoluteString.range(of: serverDomain!+"/rest/state/status") != nil  {
            if (response.statusCode >= 200  && response.statusCode < 300) {
                self.showOnBoardingIfNeed()
            }
            decisionHandler(.cancel)
            return
        }
        
        if response.mimeType != "text/html" {
            doneButton.isHidden = false
        }
        
        if #available(iOS 11.0, *) {
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies({ cookies in
                if let url = response.url {
                    self.cookiesInterceptor.intercept(cookies, url: url)
                    self.saveLogoDomain(url:url, cookies: cookies)
                }
            })
        } else if let headers = response.allHeaderFields as? [String: String], let url = response.url {
            let cookiesFromAuthHeader = cookiesFromAuthFetcher.fetch(headerValue: headers["X-Authorization"], url: url)
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
            cookiesInterceptor.intercept(cookiesFromAuthHeader, url: url)
            cookiesInterceptor.intercept(cookies, url: url)
            cookiesInterceptor.intercept(HTTPCookieStorage.shared.cookies ?? [], url: url)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request:URLRequest = navigationAction.request
        if let urlToSee = request.url?.absoluteString {
            print("=============== Navigation Url : \(urlToSee)")
        }
        // Detect the logout action in to quit this screen.
        if request.url?.absoluteString.range(of: "portal:action=Logout") != nil  {
            PushTokenSynchronizer.shared.url = request.url?.absoluteString.serverDomainWithProtocolAndPort
            PushTokenSynchronizer.shared.tryDestroyToken()
            self.defaults.setValue(false, forKey: "wasConnectedBefore")
            self.defaults.setValue("", forKey: "serverURL")
            self.defaults.setValue(false, forKey: "isLoggedIn")
            self.defaults.setValue(false, forKey: "isGoogleAuth")
            let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
            appDelegate.handleRootConnect()
        }
        let serverDomain = URL(string: self.serverURL!)?.host
        
        if !UIApplication.shared.isNetworkActivityIndicatorVisible {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        }
        
        // Display the navigation bar at login or other pages accessible for anonymous users && display the bar when luser is logged in
        // Home Page Address: portal/dw
        
        if let urlRequest = request.url {
            if (urlRequest.path.contains("/portal/dw") || urlRequest.path.contains("/portal/g/")) && !(request.url?.absoluteString.range(of: "portal:action=Logout") != nil){
                let path = urlRequest.path
                let firstIndexPath = urlRequest.path.contains("/portal/dw") ? path.components(separatedBy: "/dw")[0] : path.components(separatedBy: "/g/")[0]
                if firstIndexPath == "/portal"{
                    self.defaults.setValue(urlRequest.absoluteString, forKey: "serverURL")
                    self.defaults.setValue(true, forKey: "wasConnectedBefore")
                    self.defaults.setValue(true, forKey: "isLoggedIn")
                    navigationController?.setNavigationBarHidden(true, animated: true)
                }
            }
        }
        
        if let urlRequest = request.url {
            if let urlComponent = URLComponents(string: urlRequest.absoluteString) {
                if (urlComponent.path == "/portal/login"){
                    self.defaults.setValue(false, forKey: "isLoggedIn")
                    navigationController?.setNavigationBarHidden(false, animated: true)
                }
            }
        }
        
        if request.url?.absoluteString.range(of: "/portal/googleAuth") != nil  {
            self.defaults.setValue(true, forKey: "isGoogleAuth")
        }
        
        /*
         Open request for external link (asked by user not automatic request for external link) in a new windows (Preview Controller)
         - WKNavigationType of a automatic request is always = .Others
         - Check just for external link tapped to open the preview Controller else stay displaying the request in the some wkwebview to prevent the SAML Error.
         */
        
        if (request.url?.absoluteString.range(of: serverDomain!) == nil && navigationAction.navigationType == WKNavigationType.linkActivated){
            let previewNavigationController:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "PreviewNavigationController") as! UINavigationController
            let previewController:PreviewController = previewNavigationController.topViewController as! PreviewController
            previewController.serverURL = request.url?.absoluteString
            self.present(previewNavigationController, animated: true, completion: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    // MARK: WKUIDelegate
    
    // Called when a link opens a new window (target=_blank)
    // We simply reload the request in the existing webview
    // Cf http://stackoverflow.com/a/25853806

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        configuration.preferences = preference
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.applicationNameForUserAgent = "\(Bundle.main.appName)/\(Bundle.main.versionNumber) Version/\(UIDevice.current.systemVersion)"
        popupWebView = WKWebView(frame: .zero, configuration: configuration)
        popupWebView?.navigationDelegate = self
        popupWebView?.uiDelegate = self
        if let newWebview = popupWebView {
            self.webViewContainer.addSubview(newWebview)
            newWebview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newWebview.leadingAnchor.constraint(equalTo: self.webViewContainer.leadingAnchor),
                newWebview.trailingAnchor.constraint(equalTo: self.webViewContainer.trailingAnchor),
                newWebview.topAnchor.constraint(equalTo: self.webViewContainer.topAnchor),
                newWebview.bottomAnchor.constraint(equalTo: self.webViewContainer.bottomAnchor)
            ])
        }
        return popupWebView ?? nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }
    
    // MARK: WKScriptMessageHandler

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            print("logHandler =====> : \(message.body)")
            /// Ringtone of Incoming call not working when have ios version lower than 15.
            if #available(iOS 15.0, *) {} else {
                if "\(message.body)".contains("call") {
                    parseCallState(message:message.body as! String)
                }
            }
        }
    }
    
    func parseCallState(message:String){
        if message.contains("Incoming call") || message.contains("Call start ringing"){
            playSound(true)
        }
        if message.contains("Call declined") || message.contains("User call leaved") || message.contains("Call accepted") || message.contains("User already in the started call"){
            playSound(false)
        }
    }
    
    /*
     Display the Onboarding View Controller if:
     - The view has never been shown
     - After use has logged in
     */
    func showOnBoardingIfNeed () {
        if (self.defaults.object(forKey: Config.onboardingDidShow) == nil){
            let welcomeVC:WelcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            welcomeVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            welcomeVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(welcomeVC, animated: true, completion: {})
            self.defaults.set(NSNumber(value: true as Bool), forKey: Config.onboardingDidShow)
        }
    }
    
    /*
     Ask to load the page <serverURL>/rest/state/status
     - If the user has connected the response status code of this request = 200
     */
    func loadStateStatusPage () {
        guard let serverUrl = self.serverURL, let serverDomain = URL(string: serverUrl)?.host else { return }
        if self.webView?.url!.absoluteString.range(of: serverDomain + "/portal/intranet") != nil  {
            let statusURL = serverUrl.serverDomainWithProtocolAndPort! + "/rest/state/status"
            let url = URL(string: statusURL)
            let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Config.timeout)
            self.webView?.load(request)
        }
    }
    
    /*
     Get the remote avatar image, this need credentials in call .
     */
    
    func saveLogoDomain(url:URL,cookies:[HTTPCookie]){
        if url.absoluteString.contains("/portal/dw") {
            let logoEndPoint = "/portal/rest/v1/platform/branding/logo"
            if let scheme = url.scheme,let domain = url.host {
                let  imageUrlLogo = "\(scheme)://\(domain)\(logoEndPoint)"
                let _url = URL(string: imageUrlLogo)
                let modifier = AnyModifier { request in
                    var r = request
                    r.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
                    return r
                }
                let imgView = UIImageView()
                imgView.kf.setImage(with: _url, options: [.requestModifier(modifier)])
                self.defaults.setValue(imgView.image?.pngData(), forKey: "\(domain)")
            }
        }
    }
    
    func playSound(_ playSound:Bool) {
        guard let path = Bundle.main.path(forResource: "Ringtone", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            if playSound {
                player?.play()
            }else{
                player?.stop()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

