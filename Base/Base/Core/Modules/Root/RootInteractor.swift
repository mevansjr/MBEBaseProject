//
//  RootInteractor.swift
//
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import Branch

class RootInteractor: RootUseCase {
    
    weak var output: LoginInteractorOutput!

    func checkUserState() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ClientService.shared.getUser { (success, _) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let user = success as? User {
                ClientService.shared.currentUser = user
                print("user is logged in")
                Constants.shared.showInController()
            }
            else {
                print("user is NOT logged in")
                Constants.shared.showOutController()
            }
        }
    }

    func handleDeeplink(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) {
        Branch.getInstance().application(app,
                                         open: url,
                                         options:options
        )
    }

    func continueActivity(_ userActivity: NSUserActivity) {
        Branch.getInstance().continue(userActivity)
    }

}
