//
//  CurrencyRepository.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

struct CurrencyRepository: Repository {

    // MARK: - Repository

    func get(
        id: Int,
        handler: @escaping RepositoryCompletion<Currency>
    ) {

    }

    func list(
        handler: @escaping RepositoryCompletion<[Currency]>
    ) {

    }

    func add(
        _ item: Currency,
        handler: @escaping RepositoryCompletion<Currency>
    ) {

    }

    func delete(
        _ item: Currency,
        handler: @escaping RepositoryCompletion<Currency>
    ) {

    }

    func edit(
        _ item: Currency,
        handler: @escaping RepositoryCompletion<Currency>
    ) {

    }
}
