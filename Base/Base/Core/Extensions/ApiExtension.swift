//
//  ApiExtension.swift
//  Base
//
//  Created by Mark Evans on 6/27/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation
import ObjectMapper

extension String {
    func currentApiDomain() -> String {
        guard let isDevEnvironment = Constants.shared.plist.API?.isDevEnvironment else {
            return String().liveApiDomain()
        }
        return (isDevEnvironment) ? String().devApiDomain() : String().liveApiDomain()
    }

    func currentApiVersion() -> String {
        guard let isDevEnvironment = Constants.shared.plist.API?.isDevEnvironment else {
            return String().liveApiVersion()
        }
        return (isDevEnvironment) ? String().devApiVersion() : String().liveApiVersion()
    }

    func currentApiClientId() -> String {
        guard let isDevEnvironment = Constants.shared.plist.API?.isDevEnvironment else {
            return String().liveApiClientId()
        }
        return (isDevEnvironment) ? String().devApiClientId() : String().liveApiClientId()
    }

    func currentApiClientSecret() -> String {
        guard let isDevEnvironment = Constants.shared.plist.API?.isDevEnvironment else {
            return String().liveApiClientSecret()
        }
        return (isDevEnvironment) ? String().devApiClientSecret() : String().liveApiClientSecret()
    }
}

extension String {
    func liveApiDomain() -> String {
        guard let domain = Constants.shared.plist.API?.Production?.domain else {
            return SecureStrings.shared.ApiLiveHost
        }
        return domain
    }

    func liveApiVersion() -> String {
        guard let version = Constants.shared.plist.API?.Production?.version else {
            return SecureStrings.shared.ApiVersion
        }
        return version
    }

    func liveApiClientId() -> String {
        guard let clientId = Constants.shared.plist.API?.Production?.clientId else {
            return SecureStrings.shared.ApiClientId
        }
        return clientId
    }

    func liveApiClientSecret() -> String {
        guard let clientSecret = Constants.shared.plist.API?.Production?.clientSecret else {
            return SecureStrings.shared.ApiClientSecret
        }
        return clientSecret
    }
}

extension String {
    func devApiDomain() -> String {
        guard let domain = Constants.shared.plist.API?.Development?.domain else {
            return SecureStrings.shared.ApiDevHost
        }
        return domain
    }

    func devApiVersion() -> String {
        guard let version = Constants.shared.plist.API?.Development?.version else {
            return SecureStrings.shared.ApiVersion
        }
        return version
    }

    func devApiClientId() -> String {
        guard let clientId = Constants.shared.plist.API?.Development?.clientId else {
            return SecureStrings.shared.ApiClientId
        }
        return clientId
    }

    func devApiClientSecret() -> String {
        guard let clientSecret = Constants.shared.plist.API?.Development?.clientSecret else {
            return SecureStrings.shared.ApiClientSecret
        }
        return clientSecret
    }
}

extension ClientService {

    func setupManangerAndOAuthHandler() {
        self.oauthHandler = self.getClientOAuthHandler()
        self.manager.adapter = self.oauthHandler
        self.manager.retrier = self.oauthHandler
    }

    func setupManangerAndOAuthHandler(json: String) {
        self.oauthHandler = self.saveTokenAndRetreiveOAuthHandler(json)
        self.manager.adapter = self.oauthHandler
        self.manager.retrier = self.oauthHandler
    }

    func saveToken(_ json: String) {
        UserDefaults.standard.set(json, forKey: Token.tokenKey)
        UserDefaults.standard.synchronize()
    }

    func saveTokenAndRetreiveOAuthHandler(_ json: String) -> ClientOAuthHandler? {
        saveToken(json)
        return getClientOAuthHandler()
    }

    func clearTokenAndOAuthHandler() {
        UserDefaults.standard.removeObject(forKey: Token.tokenKey)
        UserDefaults.standard.synchronize()
        self.oauthHandler = nil
        self.manager.adapter = self.oauthHandler
        self.manager.retrier = self.oauthHandler
    }

    func getClientOAuthHandler() -> ClientOAuthHandler? {
        var token: Token?
        if let json = UserDefaults.standard.value(forKey: Token.tokenKey) as? String {
            token = Mapper<Token>().map(JSONString: json)
        }
        if token != nil {
            guard let accessToken = token?.accessToken else {
                return nil
            }

            guard let refreshToken = token?.refreshToken else {
                return nil
            }

            return ClientOAuthHandler(clientID: String().currentApiClientId(), baseURLString: String().currentApiDomain(), accessToken: accessToken, refreshToken: refreshToken)
            
        }
        return nil
    }
}
