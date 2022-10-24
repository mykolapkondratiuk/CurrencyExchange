//
//  Repository.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import Foundation

typealias RepositoryCompletion <T> = (Result<T, Error>) -> Void

protocol Repository {
    associatedtype DomainObject

    func get(
        id: Int,
        handler: @escaping RepositoryCompletion<DomainObject>
    )

    func list(
        handler: @escaping RepositoryCompletion<[DomainObject]>
    )

    func add(
        _ item: DomainObject,
        handler: @escaping RepositoryCompletion<DomainObject>
    )

    func delete(
        _ item: DomainObject,
        handler: @escaping RepositoryCompletion<DomainObject>
    )

    func edit(
        _ item: DomainObject,
        handler: @escaping RepositoryCompletion<DomainObject>
    )
}
