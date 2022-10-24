//
//  CommissionManager.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 21.10.2022.
//

enum CommissionType {
    case free
    case feeFromSixth
    case freeEachTenth
    case freeLess200Euro
}

protocol CommissionManager: AnyObject {
    
    func getFeeAfterTrade(
        currency: inout Currency,
        withCommissionType type: CommissionType
    ) -> Commission
}
