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
        Tool.applyBorderForView(defaultServerButton)
        Tool.applyBorderForView(addServerButton)
        eXoPlatformDescriptionLabel.text = NSLocalizedString("OnBoarding.Title.eXoPlatformDescription", comment: "")
        
        // set random background photo
        let bgNumber = Int(arc4random_uniform(4) + 1)
        backgroundImageView.image = UIImage(named: "background\(bgNumber)")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (ServerManager.sharedInstance.serverList.count > 0){
            defaultServer = ServerManager.sharedInstance.serverList.firstObject as? Server
            defaultServerButton.setTitle(defaultServer?.serverURL.stringURLWithoutProtocol(), forState: .Normal)
        } else {
            defaultServer = Server(serverURL: Config.communityURL)
        }
        
        self.setButtonsTitle()
        
        // the navigation controller is alway shown in this screen
        self.navigationController?.navigationBarHidden = true
    }
    
    func setButtonsTitle () {
        /*
        Set the buttons titles
        */
        if ServerManager.sharedInstance.serverList.count == 0 {
            
            defaultServerButton.setTitle(NSLocalizedString("OnBoarding.Title.DiscovereXo",comment:""), forState: .Normal)
            addServerButton.setTitle(NSLocalizedString("OnBoarding.Title.AddServer",comment:""), forState: .Normal)
            
        } else if ServerManager.sharedInstance.serverList.count == 1 {
            
            addServerButton.setTitle(NSLocalizedString("OnBoarding.Title.AddServer",comment:""), forState: .Normal)
            
        } else {
            addServerButton.setTitle(NSLocalizedString("OnBoarding.Title.Others",comment:""), forState: .Normal)
        }
        
        discovereXoTribeButton.hidden = ServerManager.sharedInstance.serverList.count == 0 || ServerManager.sharedInstance.isExist(Server(serverURL: Config.communityURL))
        
        discovereXoTribeButton.setTitle(NSLocalizedString("OnBoarding.Title.DiscovereXo", comment: ""), forState: .Normal)
        
    }

    /*
    // MARK: - Navigation
    Could be:
    - Open HomePage with default Server (segue: openDefaultServer)
    - Open HomePage with community server & point to register page (segue:openRegisterPage)
    - Open Input server screen to choose an other server (segue:openInputServer)
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        self.navigationController?.topViewController?.title = ""
        if (segue.identifier == "openDefaultServer") {
            defaultServer?.lastConnection = NSDate().timeIntervalSince1970
            ServerManager.sharedInstance.addServer(defaultServer!)
            //setup Destination VC
            let homepageVC = segue.destinationViewController as! HomePageViewController
            homepageVC.serverURL = defaultServer?.serverURL
        } else if (segue.identifier == "openRegisterPage") {

            //setup Destination VC
            let homepageVC = segue.destinationViewController as! HomePageViewController
            homepageVC.serverURL = Config.communityURL + "/portal/intranet/register"
        } else if (segue.identifier == "discovereXoCommunity") {
            let community = Server(serverURL: Config.communityURL)
            ServerManager.sharedInstance.addServer(community)
            let homepageVC = segue.destinationViewController as! HomePageViewController
            homepageVC.serverURL = community.serverURL
            
        }
    }

}
