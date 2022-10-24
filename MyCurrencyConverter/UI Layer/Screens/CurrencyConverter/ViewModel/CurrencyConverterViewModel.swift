//
//  CurrencyConverterViewModel.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import Foundation
import Promis

final class CurrencyConverterViewModel {
    // MARK: - Nested types

    // MARK: - Public properties

    // MARK: - Internal properties
    
    // Action From View to ViewModel
    var checkExchangeAction: ( (Currency, CurrencyType) -> Void )?
    var submitExchangeAction: ( (Currency, CurrencyType) -> Void )?
    
    // Notifiers from ViewModel to View
    var exchangeChecked: ( (String) -> Void )?
    var showFeeAtExchangeChecking: ( (String) -> Void )?

    var exchangeSubmittedWithFee: ( (Currency, Currency, Commission) -> Void)?

    // Work with CommissionManager
    private(set) var transactionIndex: Int = 0
    
    private(set) var currentListOfCurrency = [Currency]()
    private(set) var currentListOfCommission = [Commission]()
    
    // MARK: - Private properties

    private var checkingToReceiveCurrency: Currency?

    // MARK: - Initializable private properties

    private let container: Resolver
    private let networkService: NetworkService
    private let jsonParsingService: DataMapingType
    private let realmStorage: RealmStorageType
    private let userDefaultsStorage: UserDefaultsStorageType
    private let commissionManager: CommissionManager

    // MARK: - Initializers

    /// Initializer
    ///
    /// - Parameters:
    ///    - container: dependency injection container
    init(
        container: Resolver,
        commissionManager: CommissionManager
    ) {
        self.container = container
        self.commissionManager = commissionManager
        
        networkService = try! container.resolve(NetworkService.self) // swiftlint:disable:this force_try
        jsonParsingService = try! container.resolve(DataMapingType.self) // swiftlint:disable:this force_try
        realmStorage = try! container.resolve(RealmStorageType.self) // swiftlint:disable:this force_try
        userDefaultsStorage = try! container.resolve(UserDefaultsStorageType.self) // swiftlint:disable:this force_try
        
        submitExchangeAction = { [weak self] (currency, typeForReceive) in
            guard let self = self else { return }

            if currency.currencyType == typeForReceive {
                self.exchangeChecked?("YOU HAVE IT :)")
                return
            }

            guard let memo = self.currentListOfCurrency.first(where: { $0.currencyType == currency.currencyType })
            else {
                assertionFailure("check case")
                return
            }
            
            if memo.amount < currency.amount {
                self.exchangeChecked?("Not enough money")
                return
            }
            
            // calculate fee and new amount if need
            var currencyForCalculate = currency
            var fee = Commission(
                currencyType: currency.currencyType,
                amount: 0
            )
            let newTransactionIndex = self.transactionIndex + 1
            if newTransactionIndex > 5 {
                fee = commissionManager.getFeeAfterTrade(
                    currency: &currencyForCalculate,
                    withCommissionType: .feeFromSixth
                )
            }
            
            self.sell(
                currency: currencyForCalculate,
                toCurrencyType: typeForReceive
            ) { [weak self]  result in
                guard let self = self else { return }

                switch result {
                case .success(let receivedCurrency):
                    // Data
                    self.updateCurrentListOfCurrencyWith(
                        selledCurrency: currency,
                        receivedCurrency: receivedCurrency
                    )
                    self.updateRealmStore(with: self.currentListOfCurrency)
                    
                    self.updateCurrentListOfCommission(with: fee)
                    self.updateRealmStore(with: self.currentListOfCommission)
                    
                    self.transactionIndex = newTransactionIndex
                    self.updateRealmStore(with: TransactionCounter(transactionIndex: self.transactionIndex))

                    // UI
                    self.exchangeSubmittedWithFee?(currency, receivedCurrency, fee)
                case.failure(let error):
                    self.errorProcessing(error)
                }
            }
        }
        
        checkExchangeAction = { [weak self]  (currency, typeForReceive) in
            guard let self = self else { return }
            
            if currency.currencyType == typeForReceive {
                self.exchangeChecked?("YOU HAVE IT :)")
                return
            }

            guard let memo = self.currentListOfCurrency.first(where: { $0.currencyType == currency.currencyType })
            else {
                assertionFailure("check case")
                return
            }
            
            if memo.amount < currency.amount {
                self.exchangeChecked?("Not enough money")
                return
            }
            
            // calculate fee and new amount if need
            var currencyForCalculate = currency
            var fee = Commission(
                currencyType: currency.currencyType,
                amount: 0
            )
            let newTransactionIndex = self.transactionIndex + 1
            if newTransactionIndex > 5 {
                fee = commissionManager.getFeeAfterTrade(
                    currency: &currencyForCalculate,
                    withCommissionType: .feeFromSixth
                )
            }
            
            self.sell(
                currency: currencyForCalculate,
                toCurrencyType: typeForReceive
            ) { [weak self]  result in
                guard let self = self else { return }

                switch result {
                case .success(let currency):
                    self.exchangeChecked?(currency.amountAsString)
                    if fee.amount > 0 {
                        self.showFeeAtExchangeChecking?(fee.amountAsString)
                    }
                case.failure(let error):
                    self.errorProcessing(error)
                }
            }
        }
    }

    // MARK: - Internal methods

    func checkCurrentCurrencyValueInRepository(completion: RepositoryCompletion<([Currency], [Commission])>) {
        if userDefaultsStorage.isFirstLoad() {
            // initialize memory & Realm storages for all currencies with 1000 EUR, 0 USD, 0 JPY
            let startListOfCurrencies = [
                Currency(
                    currencyType: .euro,
                    amount: 1000
                ),
                Currency(
                    currencyType: .dollarUS,
                    amount: 0
                ),
                Currency(
                    currencyType: .yenJPN,
                    amount: 0
                )
            ]

            currentListOfCurrency = startListOfCurrencies
            self.updateRealmStore(with: currentListOfCurrency)

            // initialize memory & Realm storage for commission with 0 EUR, 0 USD, 0 JPY
            let startListOfCommission = [
                Commission(
                    currencyType: .euro,
                    amount: 0
                ),
                Commission(
                    currencyType: .dollarUS,
                    amount: 0
                ),
                Commission(
                    currencyType: .yenJPN,
                    amount: 0
                )
            ]

            currentListOfCommission = startListOfCommission
            self.updateRealmStore(with: currentListOfCommission)
            
            // initialize memory & Realm storage for counter of transaction
            transactionIndex = 10
            let counter = TransactionCounter(transactionIndex: transactionIndex)
            self.updateRealmStore(with: counter)

            completion(.success((startListOfCurrencies, startListOfCommission)))
            userDefaultsStorage.setFirstLoad(false)
            
        } else {
            let allRealmCurrencies = realmStorage.getAll(RealmCurrency.self)
            let allCurrencies = allRealmCurrencies.map { realmCurrency in
                Currency(fromRealmCurrency: realmCurrency)
            }
            currentListOfCurrency = allCurrencies

            let allRealmCommissions = realmStorage.getAll(RealmCommission.self)
            let allCommission = allRealmCommissions.map { realmCommission in
                Commission(fromRealmCommission: realmCommission)
            }
            currentListOfCommission = allCommission
            
            let counterList = realmStorage.getAll(RealmTransactionCounter.self)
            if let realmCounter = counterList.first {
                let counter = TransactionCounter(fromRealmTransactionCounter: realmCounter)
                transactionIndex = counter.transactionIndex
            } else {
                assertionFailure()
            }
            
            completion(.success((allCurrencies, allCommission)))
        }
    }

    // MARK: - Private methods
    
    private func sell(
        currency: Currency,
        toCurrencyType type: CurrencyType,
        handler: @escaping RepositoryCompletion <Currency>
    ) {
        let exchangeRequest = ExchangeCurrencyNetworkRequest(
            fromCurrency: currency,
            toCurrencyType: type
        )
        
        networkService.doRequest(exchangeRequest).thenWithResult { data -> Future<CurrencyDto> in
            let purchasingCurrencyDto = self.jsonParsingService.parse(
                data,
                toType: CurrencyDto.self
            )
            return purchasingCurrencyDto
        }.finally(queue: .main) { [weak self] future in
            guard let self = self else {
                return
            }

            switch future.state {
            case .result(let currencyDto):
                let currency = currencyDto.asDomain()
                handler(.success(currency))
                self.checkingToReceiveCurrency = currency
            case .error(let error):
                handler(.failure(error))
            case .cancelled, .unresolved:
                log.debug("\nresult.state: \(future.state)\n" )
            }
        }
    }
    
    private func errorProcessing(_ error: Error) {
    }
    
    private func updateCurrentListOfCurrencyWith(
        selledCurrency: Currency,
        receivedCurrency: Currency
    ) {
        var newList = [Currency]()
        for var currency in currentListOfCurrency {
            if currency.currencyType == selledCurrency.currencyType {
                let newAmount = currency.amount - selledCurrency.amount
                currency.setAmount(newAmount)
            }
            
            if currency.currencyType == receivedCurrency.currencyType {
                let newAmount = currency.amount + receivedCurrency.amount
                currency.setAmount(newAmount)
            }
            
            newList.append(currency)
        }
        
        self.currentListOfCurrency = newList
    }
    
    private func updateRealmStore(with currentListOfCurrency: [Currency]) {
        let realmCurrencyList = currentListOfCurrency.map { currency in
            RealmCurrency(fromCurrency: currency)
        }

        if false == self.realmStorage.save(
            list: realmCurrencyList,
            inTransactionModification: nil
        ) {
            assertionFailure("WTF")
        }
    }
    
    private func updateCurrentListOfCommission(with newCommission: Commission) {
        var newList = [Commission]()

        for var commission in currentListOfCommission {
            if commission.currencyType == newCommission.currencyType {
                let newAmount = commission.amount + newCommission.amount
                commission.setAmount(newAmount)
                
            }
            newList.append(commission)
        }
        
        self.currentListOfCommission = newList
    }
    
    private func updateRealmStore(with currentListOfCommission: [Commission]) {
        let realmCommissionList = currentListOfCommission.map { commission in
            RealmCommission(fromCommission: commission)
        }

        if false == self.realmStorage.save(
            list: realmCommissionList,
            inTransactionModification: nil
        ) {
            assertionFailure("WTF")
        }
    }
    
    private func updateRealmStore(with counter: TransactionCounter) {
        let realmCounter = RealmTransactionCounter(fromTransactionCounter: counter)
        
        if false == self.realmStorage.save(realmCounter) {
            assertionFailure("WTF")
        }
    }
}
