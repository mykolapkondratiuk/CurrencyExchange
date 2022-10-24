//
//  RealmTransactionCounter.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 23.10.2022.
//

import Foundation
import RealmSwift

class RealmTransactionCounter: Object {
    @Persisted var transactionIndex: Int = 0
    @Persisted(primaryKey: true) var id = 0
}

extension RealmTransactionCounter {
    
    convenience init(fromTransactionCounter counter: TransactionCounter) {
        self.init()
        
        self.transactionIndex = counter.transactionIndex
        self.id = CurrencyType.allCases.count
    }
}
