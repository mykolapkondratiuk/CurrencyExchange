//
//  Currency.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import Foundation

/// Conformed in app currencies
struct Currency: Equatable, CurrencyShowType {

    // MARK: - Internal properties

    let currencyType: CurrencyType
    
    var id: Int {
        return currencyType.id
    }

    var amount: Decimal

    // MARK: - CurrencyShowType

    var name: String {
        return currencyType.name
    }

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

    // MARK: - Internal methods

    mutating func setAmount(_ amount: Decimal) {
        self.amount = amount
    }
}

extension Currency {
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

    init(fromRealmCurrency currency: RealmCurrency) {
        self.currencyType = currency.currencyType.asDomainCurrencyType()

        let numberFormater = NumberFormatter()
        numberFormater.generatesDecimalNumbers = true
        let number = numberFormater.number(from: currency.ammount.stringValue)

        if let decimalAmmount = number as? Decimal {
            self.amount = decimalAmmount
        } else {
            assertionFailure("bad payload from BE")
            self.amount = Decimal(0)
        }
    }
}
