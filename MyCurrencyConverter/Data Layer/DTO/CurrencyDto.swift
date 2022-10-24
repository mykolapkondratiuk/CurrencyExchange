//
//  CurrencyDto.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import Foundation

/// Currency DTO object from BE
struct CurrencyDto: Decodable {
    let amount: String
    let currency: String
}

extension CurrencyDto {

    // MARK: - Nested types

    private enum CurrencyType: String {
        case euro = "EUR"
        case dollarUS = "USD"
        case yenJPN = "JPY"
        case unknown = "unknown"

        fileprivate init(currencyType: String) {
            self = CurrencyType(rawValue: currencyType) ?? .unknown
        }
    }

    func asDomain() -> Currency {
        let numberFormater = NumberFormatter()
        numberFormater.generatesDecimalNumbers = true
        let number = numberFormater.number(from: amount)

        guard let decimalAmmount = number as? Decimal else {
            assertionFailure("bad payload from BE")
            return Currency(
                currencyType: .dollarUS,
                amount: Decimal(0)
            )
        }

        let currencyType = CurrencyType(currencyType: currency)
        switch currencyType {
        case .euro:
            return Currency(
                currencyType: .euro,
                amount: decimalAmmount
            )
        case .dollarUS:
            return Currency(
                currencyType: .dollarUS,
                amount: decimalAmmount
            )
        case .yenJPN:
            return Currency(
                currencyType: .yenJPN,
                amount: decimalAmmount
            )
        case .unknown:
            assertionFailure("bad payload from BE")
            return Currency(
                currencyType: .dollarUS,
                amount: Decimal(0)
            )
        }
    }
}
