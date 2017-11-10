//
//  LoginContractTests.swift
//  Base
//
//  Created by Mark Evans on 5/10/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import UIKit
import XCTest
import Fakery
import ObjectMapper
@testable import Base

class LoginContractTests: XCTestCase {

    let faker = Faker()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoginView() {
        let view = LoginFakerModule().getLoginView()
        let loginPresentation = LoginPresenter()
        loginPresentation.view = view
        XCTAssertNotNil(loginPresentation.view)
    }
    
    func testLoginPresentation() {
        let view = LoginFakerModule().getLoginView()
        let loginPresentation = LoginPresenter()
        loginPresentation.view = view
        loginPresentation.interactor = LoginFakerModule().getLoginInteractor()
        loginPresentation.router = LoginFakerModule().getLoginRouter()
        loginPresentation.viewDidLoad()
        loginPresentation.didClickLogin()
        loginPresentation.loginUser(UserFaker().testUser())
        XCTAssertNotNil(loginPresentation)
    }

    func testLoginInteractor() {
        let interactor = LoginInteractor()
        interactor.loginUser("blah@email.com", password: "123")
        XCTAssertNotNil(interactor)
    }

}
