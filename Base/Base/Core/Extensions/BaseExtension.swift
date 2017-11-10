//
//  BaseExtension.swift
//  Base
//
//  Created by Mark Evans on 3/31/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation
import Alamofire

extension Dictionary {

    func serverProjectConfigPlist() -> [String: Any] {
        guard let fileURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ProjectConfigurationServer.plist") else {
            return [:]
        }
        if let dictionary = NSDictionary(contentsOf: fileURL) as? [String: Any] {
            return dictionary
        }
        return [:]
    }

    func localProjectConfigPlist() -> [String: Any] {
        if let path = Bundle.main.path(forResource: "ProjectConfiguration", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any] {
                return dictionary
            }
        }
        return [:]
    }
}

extension UIViewController {
    func titleFromPlist() -> String {
        let key = String().createControllerKey(obj: self, name: "NavigationTitle")
        guard let plist = Constants.shared.plist.Titles else {
            return ""
        }
        if let title = plist[key] {
            return title
        }
        return ""
    }
}

extension String {
    func heightForText(_ width: CGFloat, _ font: UIFont) -> CGFloat {
        if self.count == 0 {
            return 0
        }
        let attrString = NSAttributedString.init(string: self, attributes: [NSAttributedStringKey.font: font])
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = attrString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.height
    }
}

extension UILabel {
    var heightForText: CGFloat {
        guard let text = self.text else {
            return 0
        }
        guard let font = self.font else {
            return 0
        }
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedStringKey.font: font])
        let constraintRect = CGSize(width: self.bounds.size.width, height: .greatestFiniteMagnitude)
        let rect = attrString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.height
    }
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }

    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

extension UserDefaults {
    func saveUsernameAndPassword(username: String, password: String) {
        self.set(username, forKey: Constants.loginUsernameKey)
        self.set(password, forKey: Constants.loginPasswordKey)
        self.synchronize()
    }

    func getLoginUsername() -> String {
        if let username = self.value(forKey: Constants.loginUsernameKey) as? String {
            return username
        }
        return ""
    }

    func getLoginPassword() -> String {
        if let password = self.value(forKey: Constants.loginPasswordKey) as? String {
            return password
        }
        return ""
    }
}

extension String {

    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func isAlphaNumeric() -> Bool {
        let uc = NSCharacterSet.alphanumerics.inverted
        return self.rangeOfCharacter(from: uc) == nil
    }

    func isAlphaOnly() -> Bool {
        let alphaSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let uc = alphaSet.inverted
        return self.rangeOfCharacter(from: uc) == nil
    }

    func createControllerKey(obj: NSObject, name: String) -> String {
        let parsed = obj.className
        let replaced = parsed.replacingOccurrences(of: "ViewController", with: "")
        return "\(replaced.lowercased())\(name)"
    }
}

extension Date {
    func timeAgo(anotherDate: Date) -> String {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: anotherDate, to: Date())
        let days = components.day
        let hours = components.hour
        let minutes = components.minute
        let seconds = components.second
        if days! >= 1 {
            var daysString = "days"
            if days == 1 {
                daysString = String(daysString.dropLast())
            }
            return "\(String(describing: days!)) \(daysString) ago"
        }
        else if hours! < 24 && hours! >= 1 {
            var hoursString = "hours"
            if hours == 1 {
                hoursString = String(hoursString.dropLast())
            }
            return "\(String(describing: hours!)) \(hoursString) ago"
        }
        else if minutes! < 60 && minutes! > 0 {
            var minString = "minutes"
            if minutes == 1 {
                minString = String(minString.dropLast())
            }
            return "\(String(describing: minutes!)) \(minString) ago"
        }
        if seconds! < 60 && seconds! > 0 {
            var secString = "seconds"
            if seconds == 1 {
                secString = String(secString.dropLast())
            }
            return "Just Now"
        }
        return ""
    }
}

extension String {
    func appVersion() -> String {
        var version = ""
        if Bundle.main.infoDictionary != nil {
            if Bundle.main.infoDictionary!["CFBundleVersion"] != nil {
                if let v = Bundle.main.infoDictionary!["CFBundleVersion"]! as? String {
                    version = v
                }
            }
        }
        return version
    }

    func getServicePath(urlRequest: URLRequest) {
        guard let u = urlRequest.url?.absoluteString else {
            return
        }
        let url = URL(string: u)!
        let urlRequest = URLRequest(url: url)
        do {
            let encodedURLRequest = try URLEncoding.queryString.encode(urlRequest, with: nil)
            if encodedURLRequest.url != nil {
                print("servicepath: \(encodedURLRequest.url!.absoluteString)")
            }
        } catch _ {
            print("servicepath: \(String().encode(string: u))")
        }
    }

    func getCustomHeaders() -> [String: String] {
        var headers = [String: String]()
        headers["Platform"] = "ios"
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        headers["client_id"] = String().currentApiClientId()
        headers["client_secret"] = String().currentApiClientSecret()
        headers["AppVersion"] = String().appVersion()
        return headers
    }

    func encode(string: String) -> String {
        let customAllowedSet = NSCharacterSet.urlQueryAllowed
        return string.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
    }
}

extension Array {
    func filterDuplicates( includeElement: (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}

extension UINavigationController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if visibleViewController != nil {
            return (visibleViewController?.supportedInterfaceOrientations)!
        }
        return UIInterfaceOrientationMask.all
    }
}

extension UITabBarController {
    override open var shouldAutorotate: Bool {
        if selectedViewController != nil {
            return (selectedViewController?.shouldAutorotate)!
        }
        return false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if selectedViewController != nil {
            return (selectedViewController?.supportedInterfaceOrientations)!
        }
        return UIInterfaceOrientationMask.all
    }
}
