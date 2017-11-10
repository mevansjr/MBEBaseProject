//
//  RootContract.swift
//  
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved..
//

import UIKit

protocol RootWireframe: class {
    func presentLoginScreen(in window: UIWindow?)
    func presentTabBar(in window: UIWindow?)
}

protocol RootUseCase: class {
    weak var output: LoginInteractorOutput! { get set }

    func checkUserState()
    func handleDeeplink(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
    func continueActivity(_ userActivity: NSUserActivity)
}
