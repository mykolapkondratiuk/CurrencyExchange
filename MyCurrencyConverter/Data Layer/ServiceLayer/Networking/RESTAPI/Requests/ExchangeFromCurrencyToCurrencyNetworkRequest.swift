//
//  ExchangeFromCurrencyToCurrencyNetworkRequest.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import Foundation
import Alamofire

/// Request to API with aim to make exchange from one currency to other
final class ExchangeCurrencyNetworkRequest: NetworkServiceRequest {

    // MARK: - Internal properties

    let tradedCurrency: Currency
    let purchasedCurrency: Currency

    // MARK: - NetworkServiceRequest

    var url: URL {
        var urlString = self.baseURL
        urlString.append(contentsOf: "\(tradedCurrency.amount)-\(tradedCurrency.name)/\(purchasedCurrency.name)")
        urlString.append(contentsOf: "/latest")

        return URL(string: urlString)!
    }

    // MARK: - Initializers

    /// Designated Initilizer
    /// - Paremeters:
    /// - tradedCurrency: traded currency
    /// - purchasedCurrency: purchased currency
    init(
        fromCurrency tradedCurrency: Currency,
        toCurrency purchasedCurrency: Currency
    ) {
        self.tradedCurrency = tradedCurrency
        self.purchasedCurrency = purchasedCurrency
    }

    /// Convenience Initilizer
    /// - Paremeters:
    /// - tradedCurrency: traded currency
    /// - type: type of purchased currency
    convenience init(
        fromCurrency tradedCurrency: Currency,
        toCurrencyType type: CurrencyType
    ) {
        let purchasedCurrency = Currency(
            currencyType: type,
            amount: 0
        )
        self.init(
            fromCurrency: tradedCurrency,
            toCurrency: purchasedCurrency
        )
    }
}
