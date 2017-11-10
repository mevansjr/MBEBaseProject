//
//  ClientRouter.swift
//
//
//  Created by Mark Evans on 1/5/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Alamofire
import ObjectMapper

enum ClientRouter: URLRequestConvertible {
    case loginUser(String, password: String)
    case getUser()
    
    static let baseURLString = String().currentApiDomain()
    
    var method: HTTPMethod {
        switch self {
        case .loginUser:
            return .post
        case .getUser:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .loginUser:
            return "/oauth/token"
        case .getUser:
            return "/\(String().currentApiVersion())/user"
        }
    }

    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try ClientRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .loginUser(let username, let password):
            let parameters = ["username": username,
                              "password": password,
                              "grant_type": "password",
                              "client_id": String().currentApiClientId(),
                              "client_secret": String().currentApiClientSecret()]

            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .getUser:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        String().getServicePath(urlRequest: urlRequest)
        return urlRequest
    }
}
