//
//  LoginContract.swift
//
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved..
//

import UIKit

protocol TabWireframe: class {
    weak var tabBarController: UITabBarController? { get set }
    
    static func assembleModule() -> UITabBarController
}
