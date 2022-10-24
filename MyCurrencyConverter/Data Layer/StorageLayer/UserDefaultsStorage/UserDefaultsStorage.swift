//
//  UserDefaultsStorage.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import Foundation

final class UserDefaultsStorage: UserDefaultsStorageType {
    @UserDefaultValue(
        "key_isFirstLoad",
        defaultValue: true
    )
    private var isFirstLoadValue: Bool

    @UserDefaultValue(
        "key_networkEnvironment",
        defaultValue: ""
    )
    static var networkEnvironment: String

    // MARK: - UserDefaultStorageType

    func isFirstLoad() -> Bool {
        isFirstLoadValue
    }

    func setFirstLoad(_ isLoaded: Bool ) {
        isFirstLoadValue = isLoaded
    }
}
