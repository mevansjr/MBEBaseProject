//
//	User.swift
//
//	Create by Mark Evans on 5/1/2017
//	Copyright © 2017. All rights reserved.
//

import Foundation
import ObjectMapper


class User: NSObject, Mappable {

	var UserId : Int?

	class func newInstance(_ map: Map) -> Mappable? {
		return User()
	}
	required init?(map: Map){}
	override init(){}

	func mapping(map: Map) {
		UserId <- map["UserId"]
	}

}
