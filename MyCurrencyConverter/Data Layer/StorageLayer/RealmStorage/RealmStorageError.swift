//
//  RealmStorageError.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 27.09.2022.
//

enum RealmStorageError: Error {
    case cantFindItem(String)
    case saveFailed
    case deleteFailed

    var errorDescription: String? {
        switch self {
        case .cantFindItem(let message):
            return "Can't find item \(message)"
        case .deleteFailed:
            return "Can't delete item"
        case .saveFailed:
            return "Can't find item"
        }
    }
}
