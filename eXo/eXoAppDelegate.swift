//
//  eXoAppDelegate.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/15/15.
//  Copyright © 2015 eXo. All rights reserved.
//

import UIKit

@UIApplicationMain
class eXoAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var quitTimestamp:Double? // Store the timestamps when user quit the app & Enter on Background
    var navigationVC:UINavigationController?
    static let sessionTimeout:Double = 30*60 //To be verify this number, we are setting at 30mins.
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Get the root view (the enter point of storyboard)
        navigationVC = self.window!.rootViewController as? UINavigationController
        
        // Create the server manager instance to prepare the list of servers
        ServerManager.sharedInstance
        // Quick actions
        if #available(iOS 9.0, *) {
            ServerManager.sharedInstance.updateQuickAction()
            
            var launchedFromShortCut = false
            //Check for ShortCutItem
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
                launchedFromShortCut = true
                handleShortcut(shortcutItem)
            }
            //Return false incase application was lanched from shorcut to prevent
            //application(_:performActionForShortcutItem:completionHandler:) from being called
            return !launchedFromShortCut

        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        quitTimestamp = NSDate().timeIntervalSince1970
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        /*
        Verification of session timeout on server.
        When the session is timeout, go back to On-Boarding (Loggin) screen
        */
        if (NSDate().timeIntervalSince1970 - quitTimestamp!) > eXoAppDelegate.sessionTimeout  {
            if (navigationVC != nil) {
                navigationVC?.popToRootViewControllerAnimated(false)
            }
        }
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

     /*
    MARK: App Shortcut Handle
    */
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        completionHandler (handleShortcut(shortcutItem))
    }
    
    @available(iOS 9.0, *)
    /*
    Handle all kinds of shortcuts
    
    - Add a new server: visible when no server has been configured. Using this shortcut, the app will open directly the InputServerViewController where user can enter the URL of the server
    
    - Open a recent server: Direct link to a configured Server (Maxi 4 most recent servers are availabel). The App will open a HomePageViewController configured with the selected server.
    */
    func handleShortcut (shortcutItem: UIApplicationShortcutItem) -> Bool {
        var succeeded = false
        if (shortcutItem.type == ShortcutType.addNewServer) {
            succeeded = true
            if (navigationVC != nil) {
                if (navigationVC?.viewControllers.count > 0) {
                    navigationVC?.popToRootViewControllerAnimated(false)
                    let inputServer = navigationVC?.viewControllers.last?.storyboard?.instantiateViewControllerWithIdentifier("InputServerViewController")
                    navigationVC?.pushViewController(inputServer! as UIViewController, animated: false)
                }
            }
        } else if (shortcutItem.type == ShortcutType.connectRecentServer) {
            succeeded = true
            let serverDictionary = shortcutItem.userInfo
            if (serverDictionary != nil) {
                let server:Server = Server(serverDictionary: serverDictionary!)
                ServerManager.sharedInstance.addEditServer(server)
                self.quickActionOpenHomePageForURL(server.serverURL)
            }
        }
        
        return succeeded
    }
    
    func quickActionOpenHomePageForURL (stringURL:String) {
        if (navigationVC != nil) {
            if (navigationVC?.viewControllers.count > 0) {
                navigationVC?.popToRootViewControllerAnimated(false)
                let homepage = navigationVC?.viewControllers.last?.storyboard?.instantiateViewControllerWithIdentifier("HomePageViewController")
                (homepage as! HomePageViewController).serverURL  =  stringURL
                navigationVC?.pushViewController(homepage! as UIViewController, animated: false)
            }
        }
        
    }

}

