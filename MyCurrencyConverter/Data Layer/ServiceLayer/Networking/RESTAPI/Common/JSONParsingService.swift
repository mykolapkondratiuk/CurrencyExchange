//
//  JSONParsingService.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 20.09.2022.
//

import Foundation
import Promis

protocol DataMapingType {
    func parse<T: Decodable>(
        _ data: Data,
        toType: T.Type
    ) -> Future<T>
}

final class JSONParsingService: DataMapingType {
    func parse<T: Decodable>(
        _ data: Data,
        toType: T.Type
    ) -> Future<T> {
        let promise = Promise<T>()
        do {
            let object = try JSONDecoder().decode(
                T.self,
                from: data
            )
            promise.setResult(object)
        } catch {
            promise.setError(error)
        }

        return promise.future
    }
}
