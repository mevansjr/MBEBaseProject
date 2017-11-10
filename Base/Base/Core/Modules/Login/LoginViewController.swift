//
//  LoginViewController.swift
//
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved.
//

import UIKit
import RaisePlaceholder

class LoginViewController: BaseViewController {
    
    var presenter: LoginPresentation!

    @IBOutlet weak var usernameField: RaisePlaceholder!
    @IBOutlet weak var passwordField: RaisePlaceholder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }
  
    fileprivate func setupView() {
        navigationItem.title = self.titleFromPlist()
        self.usernameField.text = UserDefaults.standard.getLoginUsername()
    }

    @IBAction func loginAction() {
        guard let username = self.usernameField.text else {
            return
        }
        guard let password = self.passwordField.text else {
            return
        }
        presenter.didClickLogin(username, password: password)
    }
}

extension LoginViewController: LoginView {
    func displayLoginUser(_ user: User) {
        ClientService.shared.currentUser = user
        Constants.shared.showInController()
    }

    func displayLoginUserError(_ error: NSError) {
        print("error: \(error.localizedDescription)")
        Constants.shared.alert(vc: self, message: error.domain, title: "Error")
    }

    func showActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func hideActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
