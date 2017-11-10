//
//  Fakery+Profile.swift
//  Base
//
//  Created by Mark Evans on 5/8/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import ObjectMapper
@testable import Base

class UserFaker {

    func testUser() -> User {
        let user = User()
        user.UserId = 10
        return user
    }
    
    func testMappedUser() -> User? {
        let map = Map.init(mappingType: .toJSON, JSON: ["UserId": 10])
        let user = User.newInstance(map) as? User
        return user
    }
    
}
