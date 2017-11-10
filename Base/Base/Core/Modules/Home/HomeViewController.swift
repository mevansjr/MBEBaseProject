//
//  HomeViewController.swift
//  Base
//
//  Created by Mark Evans on 3/31/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation

class HomeViewController: BaseViewController {

    var presenter: HomePresentation!
    var user: User!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }

    fileprivate func setupView() {
        navigationItem.title = self.titleFromPlist()
    }

    @IBAction func logoutAction() {
        presenter.didClickLogout()
    }
}

extension HomeViewController: HomeView {
    func displayLoggedOutUser() {
        Constants.shared.showOutController()
    }

    func displayUser(_ user: User) {
        ClientService.shared.currentUser = user
        print("user: \(String(describing: user.toJSONString(prettyPrint: true)))")
    }

    func displayUserError(_ error: Error) {
        print("error: \(error.localizedDescription)")
    }

    func displayPermissions(_ enabled: Bool) {
        if !enabled {
            return
        }
    }

    func showActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func hideActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
