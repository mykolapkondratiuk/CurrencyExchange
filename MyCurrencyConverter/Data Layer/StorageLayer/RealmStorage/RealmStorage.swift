//
//  RealmStorage.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 26.09.2022.
//

import RealmSwift

final class RealmStorage: RealmStorageType {

    // MARK: - Private properties

    private lazy var dbStorage: URL = {
        var documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        .last!
        let fileStorage = documents.appendingPathComponent(
            "default.currencyConverter.realmDatabaseStorage",
            isDirectory: true
        )

        return fileStorage
    }()

    private var documentsDirectory: URL {
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(
            atPath: dbStorage.path,
            isDirectory: &isDir
        ) || !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(
                    at: dbStorage,
                    withIntermediateDirectories: true,
                    attributes: [:]
                )
            } catch {
                assertionFailure("can't create directory at 'dbStorage'")
            }
        }

        return dbStorage
    }

    private var realmInstance: Realm? {
        let currentSchemaVersion: UInt64 = 1
        Realm.Configuration.defaultConfiguration.schemaVersion = currentSchemaVersion
        Realm.Configuration.defaultConfiguration.migrationBlock = { _, oldSchemaVersion in
            if oldSchemaVersion < currentSchemaVersion {
                // do nothing
                // Realm will automatically detect new properties and removed properties
                // and will update the schema on disk automatically
            }
        }

        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        // now that we've told Realm how to handle the scheme change, opening the file
        // will automatically perfom the migration
        if Realm.Configuration.defaultConfiguration.inMemoryIdentifier == nil {
            Realm.Configuration.defaultConfiguration.fileURL = documentsDirectory.appendingPathComponent("mykola.realm")
        }

        do {
            let realm = try Realm()
            return realm
        } catch {
            try? FileManager.default.removeItem(at: documentsDirectory)
            return nil
        }
    }

    // MARK: - Internal methods

    static func runOnMain<T>(_ execution: @escaping () -> (T)) -> T {
        var result: T!
        guard Thread.current.isMainThread == false else {
            result = execution()
            return result
        }
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.main.async {
            result = execution()
            semaphore.signal()
        }
        semaphore.wait()

        return result
    }

    // MARK: - RealmStorageType

    @discardableResult
    func save<EntityType: Object>(
        _ object: EntityType,
        inTransactionModification: (() -> Void)? = nil
    ) -> Bool {
        return save(
            list: [object],
            inTransactionModification: inTransactionModification
        )
    }

    func save<EntityType: Object>(
        list objects: [EntityType],
        inTransactionModification: (() -> Void)? = nil
    ) -> Bool {
        return RealmStorage.runOnMain {
            autoreleasepool { () -> Bool in
                guard let realm = self.realmInstance else {
                    return false
                }
                do {
                    try realm.write {
                        inTransactionModification?()
                        realm.add(
                            objects,
                            update: .all
                        )
                    }
                } catch let error {
                    log.debug(error.localizedDescription)
                    return false
                }

                return true
            }
        }
    }

    @discardableResult
    func delete<EntityType: Object>(
        _ object: EntityType,
        cascade: Bool,
        inTransactionModification: (() -> Void)? = nil
    ) -> Bool {
        return RealmStorage.runOnMain {
            autoreleasepool { () -> Bool in
                guard let realm = self.realmInstance else {
                    return false
                }
                do {
                    if cascade {
                        object.objectSchema.properties
                            .filter { $0.isArray }
                            .map { $0.name }
                            .forEach {
                                object.dynamicList($0).forEach {
                                    self.delete(
                                        $0,
                                        cascade: cascade
                                    )
                                }
                            }
                    }
                    try realm.write {
                        inTransactionModification?()
                        realm.delete(object)
                    }
                } catch let error {
                    log.debug(error.localizedDescription)
                    return false
                }
                return true
            }
        }
    }

    func getAll<EntityType: Object>(_ ofType: EntityType.Type) -> [EntityType] {
        return RealmStorage.runOnMain {
            self.realmInstance?.objects(ofType).compactMap { $0 } ?? []
        }
    }

    func get<EntityType: Object>(
        _ type: EntityType.Type,
        forPrimaryKey key: Int
    ) -> EntityType? {
        return RealmStorage.runOnMain {
            self.realmInstance?.object(
                ofType: type,
                forPrimaryKey: key
            )
        }
    }

    func get<EntityType: Object>(
        _ ofType: EntityType.Type,
        query: String
    ) -> [EntityType] {
        return RealmStorage.runOnMain {
            self.realmInstance?.objects(ofType).filter(query).compactMap { $0 } ?? []
        }
    }

    @discardableResult
    func clearAll<EntityType: Object>(_ ofType: EntityType.Type) -> Bool {
        return RealmStorage.runOnMain {
            guard let realm = self.realmInstance else {
                return false
            }
            let items = realm.objects(ofType)

            do {
                try realm.write {
                    realm.delete(items)
                }
            } catch {
                return false
            }

            return true
        }
    }

    func clear() -> Bool {
        return RealmStorage.runOnMain {
            guard let realm = self.realmInstance else {
                return false
            }
            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch let error {
                log.debug(error.localizedDescription)
                return false
            }

          return true
        }
    }

    // MARK: - Private methods
}
