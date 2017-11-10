//
//  TabRouter.swift
//
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved.
//

import UIKit

class TabRouter: TabWireframe {
    weak var tabBarController: UITabBarController?

    static func assembleModule() -> UITabBarController {
        app.tabBarController = UITabBarController()

        let homeControler = HomeRouter().assembleModule()
        homeControler.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab-one"), tag: 0)
        homeControler.tabBarItem.title = "Home"

        app.tabBarController.viewControllers = [
            homeControler
        ]

        app.tabBarController.delegate = app.self
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Constants.shared.defaultBoldFont(size: 11), NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: .normal)
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = .white
        app.tabBarController.selectedIndex = 0

        let router = TabRouter()
        let view = app.tabBarController
        router.tabBarController = view
        return view
    }
}
