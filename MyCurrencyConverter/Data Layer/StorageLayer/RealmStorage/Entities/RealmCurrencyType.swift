//
//  RealmCurrencyType.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import RealmSwift

enum RealmCurrencyType: Int, PersistableEnum {
    case euro
    case dollarUS
    case yenJPN

    func asDomainCurrencyType() -> CurrencyType {
        switch self {
        case .euro:
            return .euro
        case .dollarUS:
            return .dollarUS
        case .yenJPN:
            return .yenJPN
        }
    }
}
