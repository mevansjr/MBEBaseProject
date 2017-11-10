//
//  UserTests.swift
//  Base
//
//  Created by Mark Evans on 5/8/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import XCTest
import Fakery
import ObjectMapper
@testable import Base

class UserTests: XCTestCase {
    let faker = Faker()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitUser() {
        let user = UserFaker().testUser()
        let json = Mapper().toJSON(user)
        guard let mapped = Mapper<User>().map(JSON: json) else {
            return
        }
        XCTAssertEqual(mapped.UserId, user.UserId!)
    }

    func testMappedUser() {
        let user = UserFaker().testMappedUser()
        XCTAssertNotNil(user)
    }
    
}
