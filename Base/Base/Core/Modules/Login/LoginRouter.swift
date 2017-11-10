//
//  LoginRouter.swift
//
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved.
//

import UIKit

class LoginRouter: LoginWireframe {
    
    weak var viewController: UIViewController?
    
    static func assembleModule() -> UIViewController {
        let view = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let router = LoginRouter()
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
