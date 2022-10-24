//
//  UserDefaultsStorageType.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

protocol UserDefaultsStorageType {
    func isFirstLoad() -> Bool
    func setFirstLoad(_ isLoaded: Bool)
}
