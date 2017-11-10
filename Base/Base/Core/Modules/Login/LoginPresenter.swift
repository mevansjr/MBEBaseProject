//
//  LoginPresenter.swift
//
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved.
//

import Foundation

class LoginPresenter: LoginPresentation {
    weak var view: LoginView?
    var interactor: LoginUseCase!
    var router: LoginWireframe!
    
    func viewDidLoad() {
    }
    
    func didClickLogin(_ username: String, password: String) {
        view?.showActivityIndicator()
        interactor.loginUser(username, password: password)
    }
}

extension LoginPresenter: LoginInteractorOutput {
    func loginUserFailed(_ error: NSError) {
        view?.hideActivityIndicator()
        view?.displayLoginUserError(error)
    }

    func loginUser(_ user: User) {
        view?.hideActivityIndicator()
        view?.displayLoginUser(user)
    }
}
