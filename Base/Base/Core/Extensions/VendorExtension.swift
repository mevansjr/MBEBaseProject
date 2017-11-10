//
//  VendorExtension.swift
//  Base
//
//  Created by Mark Evans on 6/27/17.
//  Copyright © 2017 3Advance, LLC. All rights reserved.
//

import Foundation

extension String {
    func googleAnalyticsKey() -> String {
        guard let key = Constants.shared.plist.Vendors?.GoogleAnalytics?.key else {
            return ""
        }
        return key
    }
}
