//
//  ViewProtocols.swift
//  
//
//  Created by Mark Evans on 12/17/15.
//  Copyright © 2015 3Advance, LLC. All rights reserved..
//

import Foundation

protocol ReusableView: class {}

protocol NibLoadableView: class {}

protocol IndicatableView: class {
    func showActivityIndicator()
    func hideActivityIndicator()
}
