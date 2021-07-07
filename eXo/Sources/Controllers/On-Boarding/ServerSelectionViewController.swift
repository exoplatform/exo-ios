//
//  ServerSelectionViewController.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/15/15.
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

class ServerSelectionViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var mostRecentServerLabel: UILabel!
    var defaultServer:Server?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var defaultServerButton: UIButton!
    @IBOutlet weak var addServerButton: UIButton!
    
    @IBOutlet weak var discovereXoTribeButton: UIButton!
    
    @IBOutlet weak var eXoPlatformDescriptionLabel: UILabel!
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Tool.applyBlueBorderForView(defaultServerButton)
        Tool.applyBlueBorderForView(addServerButton)
        eXoPlatformDescriptionLabel.text = NSLocalizedString("OnBoarding.Title.eXoPlatformDescription", comment: "")
        
        // set random background photo
        let bgNumber = Int(arc4random_uniform(4) + 1)
        backgroundImageView.image = UIImage(named: "background\(bgNumber)")
        
        self.navigationController?.navigationBar.barTintColor = Config.eXoYellowColor
        self.navigationController?.navigationBar.tintColor = UIColor.black
        addObserverWith(selector: #selector(rootToHome(notification:)), name: .rootFromScanURL)
    }
    
    @objc
    func rootToHome(notification:Notification){
        guard let rootURL = notification.userInfo?["rootURL"] as? String else { return }
        let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
        appDelegate.setRootToHome(rootURL)
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
            
            addServerButton.setTitle(NSLocalizedString("OnBoarding.Title.AddServer",comment:""), for: UIControl.State())
            
        } else if ServerManager.sharedInstance.serverList.count == 1 {
            
            addServerButton.setTitle(NSLocalizedString("OnBoarding.Title.AddServer",comment:""), for: UIControl.State())
            
        } else {
            
            addServerButton.setTitle(NSLocalizedString("OnBoarding.Title.Others",comment:""), for: UIControl.State())
        }
    }
    
    /**

     Show / hide the Discover eXo Tribe link.
     It's hidden if the server community.exoplatform.com exists.
     
    */
    func setDiscoverTribeLinkTitle() {
        // link is hidden if 0 server exists, or if the community website is one of the servers
        discovereXoTribeButton.isHidden = ServerManager.sharedInstance.serverList.count == 0 || ServerManager.sharedInstance.isExist(Server(serverURL: Config.communityURL))
        
        discovereXoTribeButton.setTitle(NSLocalizedString("OnBoarding.Title.DiscovereXo", comment: ""), for: UIControl.State())
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
            defaultServerButton.setTitle(NSLocalizedString("OnBoarding.Title.DiscovereXo",comment:""), for: UIControl.State())
            
        } else if (Config.communityURL.contains((defaultServer?.serverURL.stringURLWithoutProtocol())!)) {
            // server is community website
            defaultServerButton.setTitle(NSLocalizedString("Shortcut.Title.ConnnecteXoTribe",comment:""), for: UIControl.State())
            
        } else {
            // word wrapping allows to display multiple lines in the button label
            self.defaultServerButton?.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            // creating the button title string with the URL on the 2nd line
            let buttonTitle:NSString = NSString(format: "%@\n%@",
                NSLocalizedString("Shortcut.Title.ConnectTo", comment: ""),
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
    
    @IBAction func addServerTapped(_ sender: Any) {
        let signInToExoVC = ConnectToExoViewController()
        navigationController?.pushViewController(signInToExoVC, animated: true)
    }
    
    func setRootToScan(){
        let signInToeXo = QRCodeScannerViewController(nibName: "QRCodeScannerViewController", bundle: nil)
        signInToeXo.modalPresentationStyle = .overFullScreen
        present(signInToeXo, animated: false, completion: nil)
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
            defaultServer?.lastConnection = Date().timeIntervalSince1970
            ServerManager.sharedInstance.addEditServer(defaultServer!)
            //setup Destination VC
            let homepageVC = segue.destination as! HomePageViewController
            homepageVC.serverURL = defaultServer?.serverURL
        } else if (segue.identifier == "openRegisterPage") {

            //setup Destination VC
            let homepageVC = segue.destination as! HomePageViewController
            homepageVC.serverURL = Config.communityURL + "/portal/intranet/register"
        } else if (segue.identifier == "discovereXoCommunity") {
            let community = Server(serverURL: Config.communityURL)
            ServerManager.sharedInstance.addEditServer(community)
            let homepageVC = segue.destination as! HomePageViewController
            homepageVC.serverURL = community.serverURL
            
        }
    }

}
