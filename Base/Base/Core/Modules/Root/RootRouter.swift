//
//  RootRouter.swift
//  
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved..
//

import UIKit

class RootRouter: RootWireframe {
    func presentLoginScreen(in window: UIWindow?) {
        window?.makeKeyAndVisible()
        window?.rootViewController = LoginRouter.assembleModule()
    }
    
    func presentTabBar(in window: UIWindow?) {
        window?.makeKeyAndVisible()
        window?.rootViewController = TabRouter.assembleModule()
    }
}
