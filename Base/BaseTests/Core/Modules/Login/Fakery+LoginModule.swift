//
//  Fakery+LoginModule.swift
//  Base
//
//  Created by Mark Evans on 5/10/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation
import ObjectMapper
@testable import Base

class LoginFakerModule {
    func getLoginView() -> LoginView {
        return LoginViewController(nibName: "LoginViewController", bundle: nil)
    }

    func getLoginInteractor() -> LoginInteractor {
        return  LoginInteractor()
    }

    func getLoginRouter() -> LoginRouter {
        return LoginRouter()
    }
}
