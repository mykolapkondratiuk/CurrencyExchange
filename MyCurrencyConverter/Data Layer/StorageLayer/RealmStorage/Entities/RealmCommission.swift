//
//  RealmCommission.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 22.10.2022.
//

import RealmSwift
import Foundation

class RealmCommission: Object {

    @Persisted var ammount: Decimal128 = ""

    @Persisted var currencyType = RealmCurrencyType.euro

    @Persisted(primaryKey: true) var id = 0

}

extension RealmCommission {

    convenience init(fromCommission commission: Commission) {
        self.init()

        self.ammount = Decimal128(value: commission.amount)
        self.currencyType = commission.currencyType.asRealmCurrencyType()
        self.id = commission.currencyType.id
    }
}
