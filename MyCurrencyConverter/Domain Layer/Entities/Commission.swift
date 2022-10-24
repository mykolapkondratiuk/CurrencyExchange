//
//  Commission.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 22.10.2022.
//

import Foundation

/// Conformed in app commissions
struct Commission: Equatable, CurrencyShowType {

    // MARK: - Internal properties

    let currencyType: CurrencyType

    var id: Int {
        return currencyType.id
    }

    var amount: Decimal

    // MARK: - CurrencyShowType

    var amountAsString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = "."
        guard let numberString = numberFormatter.string(from: amount as NSNumber) else {
            assertionFailure("have to be string")
            return ""
        }

        return numberString
    }

    var name: String {
        return currencyType.name
    }

    // MARK: - Internal methods

    mutating func setAmount(_ amount: Decimal) {
        self.amount = amount
    }
}

extension Commission {
    init(
        currencyType: CurrencyType,
        stringDecimal: String
    ) {
        self.currencyType = currencyType

        let numberFormater = NumberFormatter()
        numberFormater.generatesDecimalNumbers = true
        let number = numberFormater.number(from: stringDecimal)

        if let decimalAmmount = number as? Decimal {
            self.amount = decimalAmmount
        } else {
            assertionFailure("bad value stringDecimal")
            self.amount = Decimal(0)
        }
    }

    init(fromRealmCommission commission: RealmCommission) {
        self.currencyType = commission.currencyType.asDomainCurrencyType()

        let numberFormater = NumberFormatter()
        numberFormater.generatesDecimalNumbers = true
        let number = numberFormater.number(from: commission.ammount.stringValue)

        if let decimalAmmount = number as? Decimal {
            self.amount = decimalAmmount
        } else {
            assertionFailure("bad payload from BE")
            self.amount = Decimal(0)
        }
    }
}
