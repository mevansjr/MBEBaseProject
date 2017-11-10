//
//  Constants.swift
//  
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved..
//

import UIKit
import Foundation
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift
import ObjectMapper
import SwiftMessages
import Fabric
import Crashlytics
import Branch

struct UI {
    static let contentWidth: CGFloat = 280.0
    static let dialogHeightSinglePermission: CGFloat = 260.0
    static let dialogHeightTwoPermissions: CGFloat = 360.0
    static let dialogHeightThreePermissions: CGFloat = 460.0
    static let maxWidth: CGFloat = 10000.0
}

struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.width)
    static let SCREEN_MIN_LENGTH = min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.height)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MIN_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MIN_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MIN_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MIN_LENGTH == 736.0
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MIN_LENGTH == 1024.0
}

let app = UIApplication.shared.delegate as! AppDelegate

@objc public class Constants: NSObject {

    static let loginUsernameKey = "Username"
    static let loginPasswordKey = "LoginPassword"
    static let appFirstLoad = "AppFirstLoad"
    static let apiAccessToken = "AccessToken"
    
    var internetReachability = Reachability()
    var hostReachability = Reachability()
    var pushRegisterInProcess = false
    var hostConnected = true
    var internetConnected = true
    var statusBarStyle = UIStatusBarStyle.lightContent
    var permissionsDialogEnabled = false
    var plist = PlistConfiguration()

    static let shared: Constants = {
        let instance = Constants()
        return instance
    }()

    func forcePortrait() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }

    func alert(vc: UIViewController, message: String?, title: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) -> Void in
        }))
        DispatchQueue.main.async {
            vc.present(ac, animated: true, completion: nil)
        }
    }

    func setupSplashController() {
        let splashController = UIViewController()
        splashController.view.frame = UIScreen.main.bounds
        splashController.view.backgroundColor = UIColor.white

        let bg = UIImageView(frame: UIScreen.main.bounds)
        bg.image = UIImage()
        bg.contentMode = .scaleAspectFill
        //splashController.view.addSubview(bg)

        let imageView = UIImageView(frame: CGRect(x: (UIScreen.main.bounds.width - 180) / 2, y: ((UIScreen.main.bounds.height - 180) / 2), width: 180, height: 180))
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFit
        //splashController.view.addSubview(imageView)

        let actView = UIActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width - 30) / 2, y: ((UIScreen.main.bounds.height - 30) / 2) + 120, width: 30, height: 30))
        actView.activityIndicatorViewStyle = .white
        actView.startAnimating()

        splashController.view.addSubview(actView)

        app.window = UIWindow(frame: UIScreen.main.bounds)
        app.window?.makeKeyAndVisible()
        app.window?.rootViewController = splashController
    }

    func readJsonFromBundle(name: String) -> Any? {
        do {
            if let file = Bundle.main.url(forResource: name, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    return object
                } else if let object = json as? [Any] {
                    return object
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    func setupRootController() {
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        UserDefaults.standard.synchronize()
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }

    func customNavbar(vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.barStyle = .default
        nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: defaultBoldFont(size: 17), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        if nav.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            nav.interactivePopGestureRecognizer!.isEnabled = true
            nav.interactivePopGestureRecognizer!.delegate = nil
        }
        return nav
    }

    func showNoConnectionUX(message: String?) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error, iconStyle: .light)
        view.configureDropShadow()
        view.button?.isHidden = true
        var msg = "You appear to be offline. Please check your internet connection."
        if message != nil {
            msg = message!
        }
        view.configureContent(title: "Warning", body: msg)
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: config, view: view)
    }

    func removeNoConnectionUX() {
        SwiftMessages.hide()
    }

    func registerForPush(userId: String) {
        if !Constants.shared.pushRegisterInProcess {
            Constants.shared.pushRegisterInProcess = true

            let action : UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            action.title = ""
            action.identifier = ""
            action.activationMode = UIUserNotificationActivationMode.foreground
            action.isAuthenticationRequired = false

            let category : UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            category.setActions([action], for: UIUserNotificationActionContext.default)
            category.identifier = ""

            let categories = NSSet(object: category) as Set

            PlayPusher.sharedInstance().requestPermission(userId, withCategories: categories)
        }
    }

    func showInController() {
        DispatchQueue.main.async {
            RootRouter().presentTabBar(in: app.window)
        }
    }

    func showOutController() {
        DispatchQueue.main.async {
            RootRouter().presentLoginScreen(in: app.window)
        }
    }

    func setupReachability() {
        NotificationCenter.default.addObserver(app.self, selector: #selector(app.reachabilityChanged(note:)), name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"), object: nil)
        Constants.shared.hostReachability = Reachability(hostName: String().currentApiDomain())
        Constants.shared.hostReachability.startNotifier()
        updateInterfaceWithReachability(Constants.shared.hostReachability)
        Constants.shared.internetReachability = Reachability.forInternetConnection()
        Constants.shared.internetReachability.startNotifier()
        updateInterfaceWithReachability(Constants.shared.internetReachability)
        if Constants.shared.internetConnected {
            removeNoConnectionUX()
        }
        else {
            showNoConnectionUX(message: nil)
        }
    }

    func updateInterfaceWithReachability(_ reachability: Reachability) {
        if reachability == Constants.shared.hostReachability {
            let connectionRequired = reachability.connectionRequired()
            if connectionRequired {
                print("Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.")
                Constants.shared.hostConnected = true
            }
            else {
                print("Cellular data network is active.\nInternet traffic will be routed through it.")
                Constants.shared.hostConnected = false
            }
        }
        if reachability == Constants.shared.internetReachability {
            Constants.shared.internetConnected = true
            let networkStatus = reachability.currentReachabilityStatus()
            switch networkStatus {
            case NotReachable:
                print("Access Not Available")
                Constants.shared.internetConnected = false
            case ReachableViaWWAN:
                print("Reachable WWAN")
                Constants.shared.internetConnected = true
            case ReachableViaWiFi:
                print("Reachable WiFi")
                Constants.shared.internetConnected = true
            default:
                print("Unknown")
                Constants.shared.internetConnected = true
            }
        }
        if Constants.shared.internetConnected {
            removeNoConnectionUX()
        }
        else {
            showNoConnectionUX(message: nil)
        }
    }

    func checkInternetConnection() {
        if Constants.shared.internetConnected {
            removeNoConnectionUX()
        }
        else {
            removeNoConnectionUX()
            showNoConnectionUX(message: nil)
        }
    }

    func applicationDidFinishLaunching(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        setupSplashController()
        Constants.shared.initProjectConfiguration { (plist) in
            if plist != nil {
                Constants.shared.plist = plist!
            }
            Constants.shared.initRootControllerWithVendors(launchOptions)
        }
    }

    func initProjectConfiguration(completion: @escaping (_ plist: PlistConfiguration?) -> ()) {
        initLocalConfigurationPlist()
        ClientService.shared.retreiveConfigurationPlist(completion: { (success) in

            if success {
                let serverDictionary = Dictionary<String, Any>().serverProjectConfigPlist()
                if serverDictionary.keys.count > 0 {
                    Constants.shared.plist = self.setupPlistVariables(dictionary: serverDictionary)
                    print("server plist :: \(Mapper<PlistConfiguration>().toJSONString(Constants.shared.plist, prettyPrint: true)!)")
                    completion(Constants.shared.plist)
                    return
                }
            }

            let localDictionary = Dictionary<String, Any>().localProjectConfigPlist()
            Constants.shared.plist = self.setupPlistVariables(dictionary: localDictionary)
            print("local plist :: \(Mapper<PlistConfiguration>().toJSONString(Constants.shared.plist, prettyPrint: true)!)")
            completion(Constants.shared.plist)
        })
    }

    func initLocalConfigurationPlist() {
        let localDictionary = Dictionary<String, Any>().localProjectConfigPlist()
        if Mapper<PlistConfiguration>().map(JSON: localDictionary) != nil {
            Constants.shared.plist = Mapper<PlistConfiguration>().map(JSON: localDictionary)!
        }
    }

    func setupPlistVariables(dictionary: Dictionary<String, Any>) -> PlistConfiguration {
        if Mapper<PlistConfiguration>().map(JSON: dictionary) != nil {
            Constants.shared.plist = Mapper<PlistConfiguration>().map(JSON: dictionary)!
        }
        if Constants.shared.plist.PermissionDialog != nil && Constants.shared.plist.PermissionDialog!.permissionsDialogEnabled != nil {
            Constants.shared.permissionsDialogEnabled = Constants.shared.plist.PermissionDialog!.permissionsDialogEnabled!
        }
        if Constants.shared.plist.UIAppearance != nil && Constants.shared.plist.UIAppearance!.statusBarStyleLight != nil {
            Constants.shared.statusBarStyle = Constants.shared.plist.UIAppearance!.statusBarStyleLight! ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default
            UIApplication.shared.statusBarStyle = Constants.shared.statusBarStyle
            UIApplication.shared.setStatusBarHidden(false, with: .none)
        }
        return Constants.shared.plist
    }

    func deleteFile(name: String) {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(name)
        do {
            try FileManager.default.removeItem(at: fileURL)
        }
        catch {
            return
        }
    }

    func initRootControllerWithVendors(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        setupSplashController()
        setupRootController()
    }

    func applicationDidStart() {
        setupReachability()
        Constants.shared.pushRegisterInProcess = false
        RootInteractor().checkUserState()
    }

    func applicationDidEnd() {
        Constants.shared.hostReachability.stopNotifier()
        Constants.shared.internetReachability.stopNotifier()
        NotificationCenter.default.removeObserver(app.self, name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"), object: nil)
    }

    func handleDeeplinks(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) {
        RootInteractor().handleDeeplink(app, open: url, options: options)
    }

    func continueActivity(_ userActivity: NSUserActivity) {
        RootInteractor().continueActivity(userActivity)
    }

    func defaultRegularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Roman", size: size)!
    }
    
    func defaultMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Medium", size: size)!
    }
    
    func defaultBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Heavy", size: size)!
    }

    func uniq<S: Sequence, E: Hashable>(source: S) -> [E] where E==S.Iterator.Element {
        var seen: [E:Bool] = [:]
        return source.filter { seen.updateValue(true, forKey: $0) == nil }
    }

}

