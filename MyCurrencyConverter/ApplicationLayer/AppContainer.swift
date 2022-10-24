//
//  AppContainer.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import Foundation

final class AppContainer: Resolver {

    // MARK: - Private properties

    private var container: Container

    // MARK: - Initializers

    init() {
        container = try! Container() // swiftlint:disable:this force_try
            .register(
                NetworkService.self,
                instance: NetworkServiceImpl()
            )
            .register(
                UserDefaultsStorageType.self,
                instance: UserDefaultsStorage()
            )
            .register(
                DataMapingType.self,
                instance: JSONParsingService()
            )
            .register(
                RealmStorageType.self,
                instance: RealmStorage()
            )

    }

    // MARK: - Internal methods

    // MARK: - Resolver

    func resolve<Dependency>(_ type: Dependency.Type) throws -> Dependency {
        try container.resolve(type)
    }
}
