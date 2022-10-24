//
//  NSObject+Ext.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 16.10.2022.
//

import Foundation

public extension NSObject {
    var className: String {
        String(describing: type(of: self))
    }

    class var className: String {
        String(describing: self)
    }
}
