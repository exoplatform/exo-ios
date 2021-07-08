//
//  eXoAppDelegate.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/15/15.
//  Copyright © 2015 eXo. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase
import UserNotifications

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@UIApplicationMain
class eXoAppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var quitTimestamp:Double? // Store the timestamps when user quit the app & Enter on Background
    var navigationVC:UINavigationController?
    var orientationLock = UIInterfaceOrientationMask.all

    static let sessionTimeout:Double = 30*60 //To be verify this number, we are setting at 30mins.
    let notificationCenter = UNUserNotificationCenter.current()
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Start Crashlytics
        Fabric.with([Crashlytics.self])
        // Push notifications
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        tryToRegisterForRemoteNotifications(application: application)
        // Quick launch
        if UserDefaults.standard.bool(forKey: "wasConnectedBefore") {
            // Memorise the last connection
            setRootToHome(UserDefaults.standard.value(forKey: "serverURL") as! String)
            return true
        }else{
            setRootOnboarding()
            return true
        }
    }
    
    func setRootToHome(_ serverURL:String){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homepageVC = sb.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            homepageVC.serverURL = serverURL
        navigationVC = UINavigationController(rootViewController: homepageVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }

    func setRootToConnect(){
        let signInToeXo = ConnectToExoViewController(nibName: "ConnectToExoViewController", bundle: nil)
        navigationVC?.navigationBar.isHidden = true
        navigationVC?.pushViewController(signInToeXo, animated: false)
    }
    
    func setRootOnboarding(){
        let rootVC = OnboardingViewController(nibName: "OnboardingViewController", bundle: nil)
        navigationVC = UINavigationController(rootViewController: rootVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        quitTimestamp = Date().timeIntervalSince1970
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        /*
        Verification of session timeout on server.
        When the session is timeout, go back to On-Boarding (Loggin) screen
        */
            if (Date().timeIntervalSince1970 - quitTimestamp!) > eXoAppDelegate.sessionTimeout  {
                if (navigationVC != nil) {
                    navigationVC?.popToRootViewController(animated: false)
                }
            }
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        application.applicationIconBadgeNumber = 0
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Reveived token! \(deviceToken.debugDescription)")
    }

     /*
    MARK: App Shortcut Handle
    */
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler (handleShortcut(shortcutItem))
    }
    
    @available(iOS 9.0, *)
    /*
    Handle all kinds of shortcuts
    
    - Add a new server: visible when no server has been configured. Using this shortcut, the app will open directly the InputServerViewController where user can enter the URL of the server
    
    - Open a recent server: Direct link to a configured Server (Maxi 4 most recent servers are availabel). The App will open a HomePageViewController configured with the selected server.
    */
    func handleShortcut (_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var succeeded = false
        if (shortcutItem.type == ShortcutType.addNewServer) {
            succeeded = true
            if (navigationVC != nil) {
                if (navigationVC?.viewControllers.count > 0) {
                    navigationVC?.popToRootViewController(animated: false)
                    let inputServer = navigationVC?.viewControllers.last?.storyboard?.instantiateViewController(withIdentifier: "InputServerViewController")
                    navigationVC?.pushViewController(inputServer! as UIViewController, animated: false)
                }
            }
        } else if (shortcutItem.type == ShortcutType.connectRecentServer) {
            succeeded = true
            let serverDictionary = shortcutItem.userInfo
            if (serverDictionary != nil) {
                let server:Server = Server(serverDictionary: serverDictionary! as NSDictionary)
                ServerManager.sharedInstance.addEditServer(server)
                self.quickActionOpenHomePageForURL(server.serverURL)
            }
        }
        return succeeded
    }
    
    func quickActionOpenHomePageForURL (_ stringURL:String) {
        if (navigationVC != nil) {
            if (navigationVC?.viewControllers.count > 0) {
                navigationVC?.popToRootViewController(animated: false)
                let homepage = navigationVC?.viewControllers.last?.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController")
                (homepage as! HomePageViewController).serverURL  =  stringURL
                navigationVC?.navigationBar.isHidden = false
                navigationVC?.pushViewController(homepage! as UIViewController, animated: false)
            }
        }
    }
    
    /*
     MARK: Firebase messaging
     */
    
    private func tryToRegisterForRemoteNotifications(application: UIApplication) {
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
                     @escaping (UIBackgroundFetchResult) -> Void) {
       // Check for new data.
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        PushTokenSynchronizer.shared.token = fcmToken
    }

	func handleNotification(userInfo: [AnyHashable: Any]) {
		if let url = userInfo["url"] as? String {
			let server:Server = Server(serverURL: Tool.extractServerUrl(sourceUrl: url))
			ServerManager.sharedInstance.addEditServer(server)
			self.quickActionOpenHomePageForURL(url)//server.serverURL
		}
	}
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
		handleNotification(userInfo: userInfo);
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
									 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		handleNotification(userInfo: userInfo);
		completionHandler(UIBackgroundFetchResult.newData)
	}

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print full message.
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        let application = UIApplication.shared
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (isSucc, error) in
            if isSucc {
                if let _userInfo = userInfo as? NSDictionary {
                    print(_userInfo)
                    if let aps = _userInfo["aps"] as? NSDictionary {
                        if let badge = aps["badge"] as? Int {
                            DispatchQueue.main.async {
                                application.applicationIconBadgeNumber = badge
                                application.registerForRemoteNotifications()
                            }
                            if let url = userInfo["url"] as? String {
                                let server:Server = Server(serverURL: Tool.extractServerUrl(sourceUrl: url))
                                var dic:Dictionary = [String:Int]()
                                for ser in ServerManager.sharedInstance.serverList {
                                    if let serverURL = (ser as? Server)?.serverURL {
                                        if serverURL.stringURLWithoutProtocol() == server.serverURL.stringURLWithoutProtocol() {
                                            dic[server.serverURL.stringURLWithoutProtocol()] = badge
                                        }
                                    }
                                }
                                self.defaults.setValue(dic, forKey: "badgeNumber")
                            }
                        }
                    }
                }
            }
        }
        // Change this to your preferred presentation option
        completionHandler([[ .badge, .alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        handleNotification(userInfo: userInfo)
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()
        completionHandler()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? eXoAppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
