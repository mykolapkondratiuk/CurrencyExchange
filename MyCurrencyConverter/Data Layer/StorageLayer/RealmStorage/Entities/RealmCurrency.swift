//
//  RealmCurrency.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import RealmSwift
import Foundation

class RealmCurrency: Object {

    @Persisted var ammount: Decimal128 = ""

    @Persisted var currencyType = RealmCurrencyType.euro

    @Persisted(primaryKey: true) var id = 0
}

extension RealmCurrency {

    convenience init(fromCurrency currency: Currency) {
        self.init()

        self.ammount = Decimal128(value: currency.amount)
        self.currencyType = currency.currencyType.asRealmCurrencyType()
        self.id = currency.currencyType.id
    }
}
