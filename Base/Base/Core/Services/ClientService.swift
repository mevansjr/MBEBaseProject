//
//  ClientService.swift
//
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Alamofire
import SDWebImage

public class ClientService {

    // MARK: Properties

    var currentUser: User?
    var manager = SessionManager()
    var oauthHandler: ClientOAuthHandler?

    typealias CompletionHandler = (_ success: Any?, _ error: NSError?) -> Void
    typealias CompletionBoolHandler = (_ success: Bool) -> Void

    // MARK: Shared Instance

    static let shared: ClientService = {
        let instance = ClientService()
        instance.setupManager()
        return instance
    }()

    // MARK: Setup Methods

    func setupManager() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = String().getCustomHeaders()
        self.manager = Alamofire.SessionManager(configuration: configuration)
        self.setupManangerAndOAuthHandler()
    }

    // MARK: OAuth Methods

    func loginUser(username: String, password: String, completion: @escaping CompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            self.manager.request(ClientRouter.loginUser(username, password: password))
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { (response) in
                    UserDefaults.standard.saveUsernameAndPassword(username: username, password: password)
                    self.handleSuccessResponseString(type: Token(), isRegister: true, response: response, completion: completion)
                })
                .responseJSON { (response) in
                    self.handleErrorResponseJSON(response: response, completion: completion)
            }
        }
    }

    func logoutUser(completion: @escaping CompletionBoolHandler)  {
        DispatchQueue.main.async {
            self.currentUser = nil
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().clearDisk()
            self.clearTokenAndOAuthHandler()
            completion(true)
        }
    }

    // MARK: Client Methods - User

    func getUser(completion: @escaping CompletionHandler) {
       DispatchQueue(label: "background", qos: .background).async {
            self.manager.request(ClientRouter.getUser())
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { (response) in
                    self.handleSuccessResponseString(type: User(), response: response, completion: completion)
                })
                .responseJSON { (response) in
                    self.handleErrorResponseJSON(response: response, completion: completion)
            }
        }
    }

    // MARK: Date Response Handling Methods

    func handleSuccessResponseString<T: Mappable>(type: T, response: DataResponse<String>, completion: @escaping CompletionHandler) -> () {
        switch response.result {
        case .success(let json):
            DispatchQueue.main.async {
                completion(Mapper<T>().map(JSONString: json), nil)
            }
        default:
            print("")
        }
    }

    func handleSuccessResponseString<T: Mappable>(type: T, isRegister: Bool, response: DataResponse<String>, completion: @escaping CompletionHandler) -> () {
        if isRegister {
            switch response.result {
            case .success(let json):
                self.setupManangerAndOAuthHandler(json: json)

                self.getUser(completion: { (success, err) in
                    if let user = success as? User {
                        DispatchQueue.main.async {
                            completion(user, nil)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(nil, err)
                        }
                    }
                })
            default:
                print("")
            }
        }
        else {
            self.handleSuccessResponseString(type: type, response: response, completion: completion)
        }
    }

    func handleErrorResponseJSON(response: DataResponse<Any>, completion: @escaping CompletionHandler) -> () {
        var error = NSError(domain: "Unknown Error", code: 500, userInfo: nil)
        switch response.result {
        case .failure(let err):
            if self.handleError(response: response, error: err as NSError) != nil {
                error = self.handleError(response: response, error: err as NSError)!
            }
            DispatchQueue.main.async {
                completion(nil, error)
            }
        default:
            print("")
        }
    }

    // MARK: Error Handling Methods

    private func handleError(response: DataResponse<Any>?, error: NSError) -> NSError? {
        if !Constants.shared.internetConnected {
            let err = NSError(domain: "The Internet connection appears to be offline.", code: 900, userInfo: nil)
            return err
        }
        guard let errorResponse = response?.response else {
            return error
        }
        var message = ""
        guard let msg = errorResponse.allHeaderFields["Message"] else {
            let err = NSError(domain: "Internal Server Error", code: 500, userInfo: nil)
            return err
        }
        if msg is String {
            message = msg as! String
        }
        else {
            return error
        }
        return NSError(domain: message, code: errorResponse.statusCode, userInfo: nil)
    }

    // MARK: Retreive Configuration Plist

    func retreiveConfigurationPlist(completion: @escaping CompletionBoolHandler) {
        let fileName = "ProjectConfigurationServer.plist"
        Constants.shared.deleteFile(name: fileName)

        guard let servicePath = Constants.shared.plist.API?.plistConfigurationDomain else {
            completion(false)
            return
        }

        if servicePath.count == 0 {
            completion(false)
            return
        }

        Alamofire.request(servicePath)
            .responsePropertyList(completionHandler: { (response) in
                if response.data != nil {
                    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName)
                    do {
                        try response.data!.write(to: fileURL, options: .atomic)
                        let serverDictionary = Dictionary<String, Any>().serverProjectConfigPlist()
                        if serverDictionary.keys.count > 0 {
                            completion(true)
                            return
                        }
                        Constants.shared.deleteFile(name: fileName)
                    }
                    catch {
                        completion(false)
                        return
                    }
                }
                completion(false)
            })
    }
    
}
