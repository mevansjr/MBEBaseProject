//
//  AppDelegate.swift
//
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import IQKeyboardManagerSwift

@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    // MARK: Application Properties

    var window: UIWindow?
    var tabBarController = UITabBarController()

    // MARK: Application Delegate Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Constants.shared.applicationDidFinishLaunching(launchOptions)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Constants.shared.applicationDidStart()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Constants.shared.applicationDidEnd()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        Constants.shared.handleDeeplinks(app, open: url, options: options)
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        Constants.shared.continueActivity(userActivity)
        return true
    }

    // MARK: Playpusher Methods

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PlayPusher.sharedInstance().registerDevice(deviceToken as Data!)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PlayPusher.sharedInstance().registerFailure()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if application.applicationState != UIApplicationState.active {
            PlayPusher.sharedInstance().handleNotification(userInfo)
        }
    }

    // MARK: TabBar Methods

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Constants.shared.checkInternetConnection()
    }

    // MARK: Reachability Methods

    @objc func reachabilityChanged(note: NSNotification) {
        if let reachability = note.object as? Reachability {
            Constants.shared.updateInterfaceWithReachability(reachability)
        }
    }
    
}
