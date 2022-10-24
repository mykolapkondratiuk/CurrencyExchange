//
//  CurrenciesBalance.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import Foundation

final class CurrenciesBalance {

    private var currenciesList: [Currency]

    init(currencies list: [Currency]) {
        currenciesList = list
    }

    func getCurrenciesBalance() -> [Currency] {
        return currenciesList
    }
}
