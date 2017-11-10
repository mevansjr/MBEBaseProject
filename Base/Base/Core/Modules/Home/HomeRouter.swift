//
//  HomeRouter.swift
//  Base
//
//  Created by Mark Evans on 3/31/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation
import UIKit


class HomeRouter: HomeWireframe {
    weak var viewController: UIViewController?

    func assembleModule() -> UIViewController {
        let view = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()

        let navigation = Constants.shared.customNavbar(vc: view)

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter

        router.viewController = view

        return navigation
    }
}

