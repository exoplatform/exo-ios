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
import UserNotifications

enum DownloadStatus {
    case started
    case completed
    case failed
}

final class HomePageViewController: eXoWebBaseController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIButton!
    
    private let cookiesInterceptor: CookiesInterceptor = CookiesInterceptorFactory().create()
    private let cookiesFromAuthFetcher = CookiesFromAuthorizationFetcher()
    
    let defaults = UserDefaults.standard
    var countRefresh:Int = 0
    var dic:Dictionary = [String:Bool]()
    var player: AVAudioPlayer?
    var destinationUrl:URL?
    var dowloadedFileName:String = "fileName"
    
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
            let captureLogSource = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
            let iOSListenerSource = "document.addEventListener('mouseout', function(){ window.webkit.messageHandlers.iosListener.postMessage('iOS Listener executed!'); })"
            let captureLogScript = WKUserScript(source: captureLogSource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            let iOSListenerScript = WKUserScript(source: iOSListenerSource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView?.configuration.userContentController.addUserScript(captureLogScript)
            webView?.configuration.userContentController.addUserScript(iOSListenerScript)
            // register the bridge script that listens for the output
            webView?.configuration.userContentController.add(
                LeakAvoider(delegate:self), name: "logHandler")
            webView?.configuration.userContentController.add(
                LeakAvoider(delegate:self), name: "iosListener")
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
    /*
       Deallocate Memory
    */
    deinit {
        print("dealloc webview")
        self.webView?.stopLoading()
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: "logHandler")
        self.popupWebView?.stopLoading()
        self.popupWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "logHandler")
    }
    
    /*
       Deallocate Memory
     */
    deinit {
        print("dealloc webview")
        self.webView?.stopLoading()
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: "logHandler")
        self.popupWebView?.stopLoading()
        self.popupWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "logHandler")
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
        /*
         if the the request is loaded from different wkWebview we have close it instead of go back.
         */
        if let _popupWebView = popupWebView {
            self.webViewDidClose(_popupWebView)
        }else if (webView?.canGoBack == true ) {
            webView?.goBack()
        }
        doneButton.isHidden = true
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
        guard let response:HTTPURLResponse = navigationResponse.response as? HTTPURLResponse else {
            if #available(iOS 14.5, *) {
                decisionHandler(.download)
            }else{
                showAlertMessage(title: "Download Unavailable".localized, msg: "You can't download the document, your os is less than iOS 15.".localized, action: .defaultAction)
                decisionHandler(.cancel)
            }
            return
        }
        
        // Handle the download .
                
        if response.url?.absoluteString.range(of: "download?resourceId=") != nil || response.url?.absoluteString.range(of: "/download/") != nil {
            if let url = response.url {
                let fileName = getFileNameFromResponse(navigationResponse.response)
                downloadData(webView: webView, fromURL: url, fileName: fileName) { success, destinationURL in
                    if success, let destinationURL = destinationURL {
                        self.fileDownloadedAtURL(url: destinationURL)
                    }
                }
            }
        }
        
        doneButton.isHidden = true
        let serverDomain = URL(string: self.serverURL!)?.host
        
        /*
         Request to /rest/state/status to check if user has connected?: 300> status code >=200 --> Connected
         */
        
        if response.url?.absoluteString.range(of: serverDomain!+"/portal/rest/state/status") != nil  {
            if (response.statusCode >= 200  && response.statusCode < 300) {
                self.showOnBoardingIfNeed()
            }
            decisionHandler(.cancel)
            return
        }
        
        if response.mimeType != "text/html" {
            doneButton.isHidden = false
        }
        
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies({ cookies in
            if let url = response.url {
                self.cookiesInterceptor.intercept(cookies, url: url)
                self.saveLogoDomain(url:url, cookies: cookies)
            }
        })
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request:URLRequest = navigationAction.request
        if let urlToSee = request.url?.absoluteString {
            print("=============== Navigation Url : \(urlToSee)")
        }
        
        // Detect the logout action in to quit this screen.
        
        if request.url?.absoluteString.range(of: "portal:action=Logout") != nil  {
            logout(request: request)
        }
        
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
        if let serverDomain = URL(string: self.serverURL!)?.host {
            if (request.url?.absoluteString.range(of: serverDomain) == nil && navigationAction.navigationType == WKNavigationType.linkActivated){
                let previewNavigationController:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "PreviewNavigationController") as! UINavigationController
                let previewController:PreviewController = previewNavigationController.topViewController as! PreviewController
                previewController.serverURL = request.url?.absoluteString
                self.present(previewNavigationController, animated: true, completion: nil)
                decisionHandler(.cancel)
                return
            }
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
        popupWebView = WKWebView(frame: .zero, configuration: configuration)
        popupWebView?.navigationDelegate = self
        popupWebView?.uiDelegate = self
        if let newWebview = popupWebView {
            // Add a custom values to the default user agent
            webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
                if let userAgent = result as? String {
                    newWebview.customUserAgent = userAgent + " \(Bundle.main.appName)/\(Bundle.main.versionNumber) Version/\(UIDevice.current.systemVersion) Safari/604.1 (iOS)"
                }
            }
            self.webViewContainer.addSubview(newWebview)
            newWebview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newWebview.leadingAnchor.constraint(equalTo: self.webViewContainer.leadingAnchor),
                newWebview.trailingAnchor.constraint(equalTo: self.webViewContainer.trailingAnchor),
                newWebview.topAnchor.constraint(equalTo: self.webViewContainer.topAnchor),
                newWebview.bottomAnchor.constraint(equalTo: self.webViewContainer.bottomAnchor)
            ])
            newWebview.load(navigationAction.request)
        }
        return popupWebView ?? nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }
    
    // MARK: WKScriptMessageHandler

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if #available(iOS 15.0, *) {} else {
            if message.name == "logHandler" {
                print("logHandler =====> : \(message.body)")
                /// Ringtone of Incoming call not working when have ios version lower than 15.
                if "\(message.body)".contains("call") {
                    parseCallState(message:message.body as! String)
                }
            }
        }
        if message.name == "iosListener" {
            print("iosListener =====> : \(message.body)")
            self.view.endEditing(true)
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
       Display the Connect page View Controller if:
       - The view has never been shown
       - After user has logged in
       */
       func showOnBoardingIfNeed() {
           if (UserDefaults.standard.object(forKey: Config.onboardingDidShow) == nil){
               UserDefaults.standard.set(NSNumber(value: true as Bool), forKey: Config.onboardingDidShow)
               let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
               appDelegate.handleRootConnect()
           }
       }
       /*
        Ask to load the page <serverURL>/rest/state/status
        - If the user has connected the response status code of this request = 200
        */
       func loadStateStatusPage() {
           guard let serverUrl = self.serverURL, let serverDomain = URL(string: serverUrl)?.host else { return }
           if self.webView?.url!.absoluteString.range(of: serverDomain + "/portal/dw") != nil  {
               let statusURL = serverUrl.serverDomainWithProtocolAndPort! + "/portal/rest/state/status"
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
    
    // Logout : Destroy token device as well as clear user data .
    
    func logout(request:URLRequest) {
        PushTokenSynchronizer.shared.url = request.url?.absoluteString.serverDomainWithProtocolAndPort
        PushTokenSynchronizer.shared.tryDestroyToken()
        self.defaults.setValue(false, forKey: "wasConnectedBefore")
        self.defaults.setValue("", forKey: "serverURL")
        self.defaults.setValue(false, forKey: "isLoggedIn")
        self.defaults.setValue(false, forKey: "isGoogleAuth")
        clearCookiesAndCache()
        let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
        appDelegate.handleRootConnect()
    }
    
    func clearCookiesAndCache(){
        /// old API cookies
        for cookie in HTTPCookieStorage.shared.cookies ?? [] {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        /// URL cache
        URLCache.shared.removeAllCachedResponses()
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
    }
    
}

extension HomePageViewController {
    
    // Download the file.
    
    private func downloadData(webView:WKWebView,fromURL url:URL,fileName:String,completion:@escaping (Bool, URL?) -> Void) {
        showDownloadBanner(fileName, .started)
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies() { cookies in
            let session = URLSession.shared
            session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
            let task = session.downloadTask(with: url) { localURL, urlResponse, error in
                if let localURL = localURL {
                    let destinationURL = self.moveDownloadedFile(url: localURL, fileName: fileName)
                    self.showDownloadBanner(fileName, .completed)
                    completion(true, destinationURL)
                }else {
                    self.showDownloadBanner(fileName, .failed)
                    completion(false, nil)
                }
            }
            task.resume()
        }
    }
    
    // Get the file name.
    
    private func getFileNameFromResponse(_ response:URLResponse) -> String {
        if let httpResponse = response as? HTTPURLResponse {
            let headers = httpResponse.allHeaderFields
            print("headers file ======> \(headers)")
            if let disposition = headers["Content-Disposition"] as? String {
                print("Content-Disposition ======> \(disposition)")
                let components = disposition.components(separatedBy: ";")
                if components.count > 1 {
                    let innerComponents = components[1].components(separatedBy: "=")
                    if innerComponents.count > 1 {
                        if innerComponents[0].contains("filename") {
                            print(innerComponents[1])
                            return innerComponents[1].replacingOccurrences(of: "\"", with: "")
                        }
                    }
                }
            }
        }
        return "default"
    }
    
    // Move the file to specific destination.
    
    private func moveDownloadedFile(url:URL, fileName:String) -> URL {
        let tempDir = NSTemporaryDirectory()
        let destinationPath = tempDir + fileName
        let destinationURL = URL(fileURLWithPath: destinationPath)
        try? FileManager.default.removeItem(at: destinationURL)
        try? FileManager.default.moveItem(at: url, to: destinationURL)
        return destinationURL
    }
    
    // Show UIActivityViewController to interacte with the file.
    
    func fileDownloadedAtURL(url: URL) {
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

// MARK: - WKDownloadDelegate.

@available(iOS 14.5, *)
extension HomePageViewController:WKDownloadDelegate {
    // Set the destination path to save our file.
    func download(_ download: WKDownload, decideDestinationUsing
                  response: URLResponse, suggestedFilename: String,
                  completionHandler: @escaping (URL?) -> Void) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destinationUrl = documentsUrl.appendingPathComponent(suggestedFilename)
        try? FileManager.default.removeItem(at: destinationUrl!)
        dowloadedFileName = suggestedFilename
        showDownloadBanner(dowloadedFileName,.started)
        completionHandler(destinationUrl)
    }
    
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
    
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = self
    }
    
    func downloadDidFinish(_ download: WKDownload) {
        print("File Successfully Downloaded")
        showDownloadBanner(dowloadedFileName,.completed)
        self.fileDownloadedAtURL(url: destinationUrl!)
    }
    
    func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        print("Failed to download the file: \(error)")
        showDownloadBanner(dowloadedFileName,.failed)
    }
    
}
