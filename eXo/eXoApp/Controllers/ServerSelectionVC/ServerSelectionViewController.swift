//
//  ServerSelectionViewController.swift
//  eXo
//
//  Created by eXo Development on 21/04/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class ServerSelectionViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var mostRecentServerLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var defaultServerButton: UIButton!
    @IBOutlet weak var addServerButton: UIButton!
    @IBOutlet weak var discovereXoTribeButton: UIButton!
    @IBOutlet weak var eXoPlatformDescriptionLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    var defaultServer:Server?

    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Tool.applyBlueBorderForView(defaultServerButton)
        Tool.applyBlueBorderForView(addServerButton)
        eXoPlatformDescriptionLabel.text = "OnBoarding.Title.eXoPlatformDescription".localized()
        
        // set random background photo
        let bgNumber = Int(arc4random_uniform(4) + 1)
        backgroundImageView.image = UIImage(named: "background\(bgNumber)")
        
        self.navigationController?.navigationBar.barTintColor = Config.eXoYellowColor
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (ServerManager.sharedInstance.serverList.count > 0){
            defaultServer = ServerManager.sharedInstance.serverList.firstObject as? Server
        } else {
            defaultServer = Server(serverURL: Config.communityURL)
        }
        // the navigation controller is alway shown in this screen
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Buttons labels are updated in viewDidAppear
        // because in viewWillAppear there is a bug:
        // when we swipe back from another screen,
        // and the default button has an attributed label,
        // the label may not be displayed.
        self.setButtonsTitleWithoutAnimation()
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
         navigationController?.pushViewController(vc,
         animated: true)
    }
    
    @IBAction func defaultServeurTapped(_ sender: Any) {
        self.navigationController?.topViewController?.title = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homepageVC = storyboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            defaultServer?.lastConnection = Date().timeIntervalSince1970
            ServerManager.sharedInstance.addEditServer(defaultServer!)
            //setup Destination VC
            homepageVC.serverURL = defaultServer?.serverURL
         navigationController?.pushViewController(homepageVC,
         animated: true)
    }
    
    @IBAction func addNewServeurTapped(_ sender: Any) {
        self.navigationController?.topViewController?.title = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InputServerViewController") as! InputServerViewController
         navigationController?.pushViewController(vc,
         animated: true)
    }
    
    @IBAction func discoverExoTripTapped(_ sender: Any) {
        self.navigationController?.topViewController?.title = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homepageVC = storyboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        let community = Server(serverURL: Config.communityURL)
        ServerManager.sharedInstance.addEditServer(community)
        homepageVC.serverURL = community.serverURL
         navigationController?.pushViewController(homepageVC,
         animated: true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // Update the default button when the orientation changes
        // so the URL label can use all the screen width with a larger font
        UIView.performWithoutAnimation({ () -> Void in
            self.setDefaultServerButtonTitle()
            self.defaultServerButton.layoutIfNeeded()
        })
    }
    
    func setButtonsTitle () {
        
        // Default Server button
        self.setDefaultServerButtonTitle()
        // Add / Other Server button
        self.setOtherServerButtonTitle()
        // Discover eXo Tribe link
        self.setDiscoverTribeLinkTitle()
    }
    
    func setButtonsTitleWithoutAnimation () {
        // Update all the button labels without a fade animation.
        // We disable animations because it doesn't look nice
        // when we rotate or navigate back to the screen.
        UIView.performWithoutAnimation({ () -> Void in
            self.setButtonsTitle()
            self.defaultServerButton.layoutIfNeeded()
            self.addServerButton.layoutIfNeeded()
            self.discovereXoTribeButton.layoutIfNeeded()
        })
    }
    
    /**
     
     Update the Add / Other button label
     
    */
    func setOtherServerButtonTitle() {
        
        if ServerManager.sharedInstance.serverList.count == 0 {
            
            addServerButton.setTitle("OnBoarding.Title.AddServer".localized(), for: UIControl.State())
            
        } else if ServerManager.sharedInstance.serverList.count == 1 {
            
            addServerButton.setTitle("OnBoarding.Title.AddServer".localized(), for: UIControl.State())
            
        } else {
            
            addServerButton.setTitle("OnBoarding.Title.Others".localized(), for: UIControl.State())
        }
    }
    
    /**

     Show / hide the Discover eXo Tribe link.
     It's hidden if the server community.exoplatform.com exists.
     
    */
    func setDiscoverTribeLinkTitle() {
        // link is hidden if 0 server exists, or if the community website is one of the servers
        discovereXoTribeButton.isHidden = ServerManager.sharedInstance.serverList.count == 0 || ServerManager.sharedInstance.isExist(Server(serverURL: Config.communityURL))
        
        discovereXoTribeButton.setTitle("OnBoarding.Title.DiscovereXo".localized(), for: UIControl.State())
    }
    
    /**

     Update the Default Server button label

    */
    func setDefaultServerButtonTitle() {
        // clear existing title
        defaultServerButton?.setTitle("", for: UIControl.State())
        defaultServerButton?.setAttributedTitle(NSMutableAttributedString(string: "", attributes: nil), for: UIControl.State())

        if (ServerManager.sharedInstance.serverList.count == 0) {
            // no server -> show button Discover eXo Tribe
            defaultServerButton.setTitle("OnBoarding.Title.DiscovereXo".localized(), for: UIControl.State())
            
        } else if (Config.communityURL.contains((defaultServer?.serverURL.stringURLWithoutProtocol())!)) {
            // server is community website
            defaultServerButton.setTitle("Shortcut.Title.ConnnecteXoTribe".localized(), for: UIControl.State())
            
        } else {
            // word wrapping allows to display multiple lines in the button label
            self.defaultServerButton?.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            // creating the button title string with the URL on the 2nd line
            let buttonTitle:NSString = NSString(format: "%@\n%@",
                                                "Shortcut.Title.ConnectTo".localized(),
                (defaultServer?.serverURL.stringURLWithoutProtocol())!)
        
            // getting the range to separate the button text and the button URL
            let newlineRange: NSRange = buttonTitle.range(of: "\n")
            
            // getting both substrings
            var buttonText: NSString = ""
            var buttonURL: NSString = ""
            if(newlineRange.location != NSNotFound) {
                buttonText = buttonTitle.substring(to: newlineRange.location) as NSString
                buttonURL = buttonTitle.substring(from: newlineRange.location) as NSString
            }
            
            // assigning different styles to both substrings
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = NSTextAlignment.center
            paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            
            let buttonTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17.0),
                                        NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                        NSAttributedString.Key.foregroundColor: UIColor.black]
            let attrStrTitle = NSMutableAttributedString(
                string: buttonText as String,
                attributes: buttonTextAttributes)
            
            // font size calculated from screen width and URL length, cf method description below
            let fontSizeURL = calculateURLFontSize(Int(UIScreen.main.bounds.width), urlLength: buttonURL.length)
            let buttonURLAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSizeURL),
                                       NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                       NSAttributedString.Key.foregroundColor: UIColor.black]
            let attrStrURL = NSMutableAttributedString(
                string: buttonURL as String,
                attributes: buttonURLAttributes)
            
            // appending both attributed strings
            attrStrTitle.append(attrStrURL)
            
            // assigning the result attributed strings to the button
            self.defaultServerButton?.setAttributedTitle(attrStrTitle, for: UIControl.State())
        }
    }
    
    /**
     
     Calculate the size of the font for the URL label, based on the screen width and
     the URL length.
     - ratio >= 8 : font size = 12 pts
     - ratio >= 7 : font size = 10 pts
     - ratio <  7 : font size = 9 pts
     
     Examples:
     - **9 pts** for *plfent-4.3.0-rc1-1.acceptance5.exoplatform.org* on **iPhone 5**
     - **12 pts** for *plfent-4.3.0-rc1-1.acceptance5.exoplatform.org* on **iPhone 6S**
     
     */
    func calculateURLFontSize(_ screenWidth: Int, urlLength: Int) -> CGFloat {
        let ratio = screenWidth / urlLength
        if (ratio >= 8) {
            return 12.0
        } else if (ratio >= 7) {
            return 10.0
        } else {
            return 9.0
        }
    }

    /*
    // MARK: - Navigation
    
    Could be:
    - Open HomePage with default Server (segue: openDefaultServer)
    - Open HomePage with community server & point to register page (segue:openRegisterPage)
    - Open Input server screen to choose an other server (segue:openInputServer)
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.navigationController?.topViewController?.title = ""
        if (segue.identifier == "openDefaultServer") {
//            defaultServer?.lastConnection = Date().timeIntervalSince1970
//            ServerManager.sharedInstance.addEditServer(defaultServer!)
//            //setup Destination VC
//            let homepageVC = segue.destination as! HomePageViewController
//            homepageVC.serverURL = defaultServer?.serverURL
        } else if (segue.identifier == "openRegisterPage") {

            //setup Destination VC
            let homepageVC = segue.destination as! HomePageViewController
            homepageVC.serverURL = Config.communityURL + "/portal/intranet/register"
        } else if (segue.identifier == "discovereXoCommunity") {
//            let community = Server(serverURL: Config.communityURL)
//            ServerManager.sharedInstance.addEditServer(community)
//            let homepageVC = segue.destination as! HomePageViewController
//            homepageVC.serverURL = community.serverURL
            
        }
    }

}
