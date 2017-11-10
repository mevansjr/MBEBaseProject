//
//  HomePresenter.swift
//  Base
//
//  Created by Mark Evans on 3/31/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation


class HomePresenter: HomePresentation {

    // MARK: Properties

    weak var view: HomeView?
    var interactor: HomeUseCase!
    var router: HomeWireframe!

    func viewDidAppear(_ animated: Bool) {
        interactor.showPermissions()
    }

    func viewDidLoad() {
        view?.showActivityIndicator()
        interactor.getUser()
    }

    func didClickLogout() {
        view?.showActivityIndicator()
        interactor.logoutUser()
    }
}

extension HomePresenter: HomeInteractorOutput {
    func userLoggedOut() {
        view?.hideActivityIndicator()
        view?.displayLoggedOutUser()
    }

    func getUserFailed(_ error: Error) {
        view?.hideActivityIndicator()
        view?.displayUserError(error)
    }

    func getUser(_ user: User) {
        view?.hideActivityIndicator()
        view?.displayUser(user)
    }

    func showPermissions(_ enabled: Bool) {
        view?.displayPermissions(enabled)
    }
}
