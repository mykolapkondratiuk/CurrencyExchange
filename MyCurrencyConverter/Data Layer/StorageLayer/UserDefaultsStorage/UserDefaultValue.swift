//
//  UserDefaultValue.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import Foundation

@propertyWrapper
struct UserDefaultValue<T> {

    private let key: String
    private let defaultValue: T

    init(
        _ key: String,
        defaultValue: T
    ) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: key
            )
        }
    }
}
