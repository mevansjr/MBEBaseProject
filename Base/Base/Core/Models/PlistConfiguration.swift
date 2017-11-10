//
//  PlistConfiguration.swift
//  Base
//
//  Created by Mark Evans on 6/27/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation
import ObjectMapper


class PlistConfiguration : NSObject, Mappable {

    var Titles: Dictionary<String, String>?
    var UIAppearance: PlistUIAppearance?
    var PermissionDialog: PlistPermissionDialog?
    var Vendors: PlistVendors?
    var API: PlistAPI?

    class func newInstance(_ map: Map) -> Mappable? {
        return PlistConfiguration()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map) {
        Titles <- map["Titles"]
        UIAppearance <- map["UIAppearance"]
        PermissionDialog <- map["PermissionDialog"]
        Vendors <- map["Vendors"]
        API <- map["API"]
    }
    
}

class PlistUIAppearance : NSObject, Mappable {

    var statusBarStyleLight: Bool?

    class func newInstance(_ map: Map) -> Mappable? {
        return PlistUIAppearance()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map) {
        statusBarStyleLight <- map["statusBarStyleLight"]
    }
    
}

class PlistPermissionDialog : NSObject, Mappable {

    var permissionsDialogEnabled: Bool?

    class func newInstance(_ map: Map) -> Mappable? {
        return PlistPermissionDialog()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map) {
        permissionsDialogEnabled <- map["permissionsDialogEnabled"]
    }
    
}

class PlistAPI : NSObject, Mappable {

    var plistConfigurationDomain: String?
    var isDevEnvironment: Bool?
    var Production: PlistApiEndpoint?
    var Development: PlistApiEndpoint?

    class func newInstance(_ map: Map) -> Mappable? {
        return PlistAPI()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map) {
        plistConfigurationDomain <- map["plistConfigurationDomain"]
        isDevEnvironment <- map["isDevEnvironment"]
        Production <- map["Production"]
        Development <- map["Development"]
    }
    
}

class PlistApiEndpoint : NSObject, Mappable {

    var domain: String?
    var version: String?
    var clientId: String?
    var clientSecret: String?

    class func newInstance(_ map: Map) -> Mappable? {
        return PlistApiEndpoint()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map) {
        domain <- map["domain"]
        version <- map["version"]
        clientId <- map["clientId"]
        clientSecret <- map["clientSecret"]
    }
    
}

class PlistVendors : NSObject, Mappable {

    var GoogleAnalytics: PlistGoogleAnalytics?
    var PlayPusher: PlistPlayPusher?

    class func newInstance(_ map: Map) -> Mappable? {
        return PlistVendors()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map) {
        GoogleAnalytics <- map["GoogleAnalytics"]
        PlayPusher <- map["PlayPusher"]
    }

}

class PlistGoogleAnalytics : NSObject, Mappable {

    var key: String?

    class func newInstance(_ map: Map) -> Mappable? {
        return PlistGoogleAnalytics()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map) {
        key <- map["key"]
    }

}

class PlistPlayPusher : NSObject, Mappable {

    var clientId: String?
    var clientSecret: String?

    class func newInstance(_ map: Map) -> Mappable? {
        return PlistPlayPusher()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map) {
        clientId <- map["clientId"]
        clientSecret <- map["clientSecret"]
    }
    
}
