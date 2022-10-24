//
//  CurrencyType.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 27.09.2022.
//

import Foundation

enum CurrencyType: CaseIterable {
    case euro
    case dollarUS
    case yenJPN

    var name: String {
        switch self {
        case .euro:
            return "EUR"
        case .dollarUS:
            return "USD"
        case .yenJPN:
            return "JPY"
        }
    }

    var id: Int {
        let array = Self.allCases
        let id = array.firstIndex(of: self)!

        return id
    }

    static var allNames: [String] {
        return CurrencyType.allCases.map { $0.name }
    }

    func asRealmCurrencyType() -> RealmCurrencyType {
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

extension CurrencyType {
    static func create(from string: String) -> CurrencyType? {
        switch string {
        case "EUR":
            return .euro
        case "USD":
            return .dollarUS
        case "JPY":
            return .yenJPN
        default:
            return nil
        }
    }
}
