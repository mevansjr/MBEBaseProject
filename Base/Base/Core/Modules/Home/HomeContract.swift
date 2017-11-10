//
//  HomeContract.swift
//  Base
//
//  Created by Mark Evans on 3/31/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation

protocol HomeView: IndicatableView {
    var presenter: HomePresentation! { get set }
    func displayUser(_ user: User)
    func displayUserError(_ error: Error)
    func displayPermissions(_ enabled: Bool)
    func displayLoggedOutUser()
}

protocol HomePresentation: class {
    weak var view: HomeView? { get set }
    var interactor: HomeUseCase! { get set }
    var router: HomeWireframe! { get set }
    func viewDidLoad()
    func viewDidAppear(_ animated: Bool)
    func didClickLogout()
}

protocol HomeUseCase: class {
    weak var output: HomeInteractorOutput! { get set }
    func getUser()
    func showPermissions()
    func logoutUser()
}

protocol HomeInteractorOutput: class {
    func getUser(_ user: User)
    func getUserFailed(_ error: Error)
    func showPermissions(_ enabled: Bool)
    func userLoggedOut()
}

protocol HomeWireframe: class {
    weak var viewController: UIViewController? { get set }

    func assembleModule() -> UIViewController
}
