//
//  RealmStorageType.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import RealmSwift

protocol RealmStorageType {
    @discardableResult
    func save<EntityType: Object>(
        _ object: EntityType,
        inTransactionModification: (() -> Void)?
    ) -> Bool

    func save<EntityType: Object>(
        list objects: [EntityType],
        inTransactionModification: (() -> Void)?
    ) -> Bool

    @discardableResult
    func delete<EntityType: Object>(
        _ object: EntityType,
        cascade: Bool,
        inTransactionModification: (() -> Void)?
    ) -> Bool

    func getAll<EntityType: Object>(
        _ ofType: EntityType.Type
    ) -> [EntityType]

    func get<EntityType: Object>(
        _ type: EntityType.Type,
        forPrimaryKey key: Int
    ) -> EntityType?

    func get<EntityType: Object>(
        _ ofType: EntityType.Type,
        query: String
    ) -> [EntityType]

    @discardableResult
    func clearAll<EntityType: Object>(_ ofType: EntityType.Type) -> Bool

    func clear() -> Bool
}

extension RealmStorageType {
    @discardableResult
    func save<EntityType: Object>(
        _ object: EntityType,
        inTransactionModification: (() -> Void)? = nil
    ) -> Bool {
        return save(
            object,
            inTransactionModification: inTransactionModification
        )
    }

    @discardableResult
    func delete<EntityType: Object>(
        _ object: EntityType,
        cascade: Bool = true,
        inTransactionModification: (() -> Void)? = nil
    ) -> Bool {
        return delete(
            object,
            cascade: cascade,
            inTransactionModification: inTransactionModification
        )
    }
}
