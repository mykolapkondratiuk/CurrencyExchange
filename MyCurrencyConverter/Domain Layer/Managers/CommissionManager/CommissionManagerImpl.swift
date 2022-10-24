//
//  CommissionManagerImpl.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 21.10.2022.
//

import Foundation

final class CommissionManagerImpl: CommissionManager {
    
    // MARK: - Nested types
        
    // MARK: - Public properties
        
    // MARK: - Internal properties

    // MARK: - Private properties

    // MARK: - Initializable private properties

    // MARK: - Initializers
    /// Designated initializer
    /// Parameters:
    /// - currencies:  Array of currencies for showing in carousel
    init() {}

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }

    // MARK: - Life Cycle

    // MARK: - Public methods
        
    // MARK: - Internal methods
    
    // MARK: - CommissionManager
    
    func getFeeAfterTrade(
        currency: inout Currency,
        withCommissionType type: CommissionType
    ) -> Commission {
        let emptyCommission = Commission(
            currencyType: currency.currencyType,
            amount: 0
        )
        
        switch type {
        case .free:
            return emptyCommission
        case .feeFromSixth:
            let doubleValue = Double(truncating: NSDecimalNumber(decimal: currency.amount))
            let newAmountDouble = doubleValue * 0.993
            let roundedNewAmountDouble = round(Double(newAmountDouble) * 100) / 100.0
            let newAmount = Decimal(roundedNewAmountDouble)
            let feeAmount = currency.amount - newAmount
            log.debug("\nnewAmount: \(newAmount)\nfeeAmount: \(feeAmount)\n")
            currency.setAmount(newAmount)
            return Commission(
                    currencyType: currency.currencyType,
                    amount: feeAmount
                )
        case .freeEachTenth:
            return emptyCommission
        case .freeLess200Euro:
            return emptyCommission
        }
        
    }
}
