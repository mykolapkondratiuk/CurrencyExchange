//
//  TransactionCounter.swift
//  
//
//  Created by Mykola Kondratiuk on 23.10.2022.
//

import Foundation

struct TransactionCounter: Equatable {

    // MARK: - Internal properties
    
    var transactionIndex: Int
    
    // MARK: - Internal methods
    
    mutating func setTransactionIndex(_ index: Int) {
        self.transactionIndex = index
    }
}

extension TransactionCounter {
    
    init(fromRealmTransactionCounter counter: RealmTransactionCounter) {
        self.transactionIndex = counter.transactionIndex
    }
}
