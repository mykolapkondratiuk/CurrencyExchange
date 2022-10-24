//
//  NetworkError.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import Foundation

enum NetworkError: LocalizedError, CustomStringConvertible {

    case genericError
    case serverError(Data?)
    case validation(data: Data)

    static func errorFrom(data: Data) -> String {
        do {
            let validationErrors = try JSONDecoder().decode(
                [ConcreteErrorDto].self,
                from: data
            )
            return validationErrors.map { $0.message }.joined(separator: ",")
        } catch {
            do {
                let serverError = try JSONDecoder().decode(
                    ServerConcreteErrorDto.self,
                    from: data
                )
                return serverError.detail
            } catch {
                do {
                    let other = try JSONSerialization.jsonObject(
                        with: data,
                        options: []
                    )
                    return "\(other)"
                } catch {
                    return String(data: data, encoding: .utf8) ?? ""
                }
            }
        }
    }

    private var message: String {
        switch self {
        case .genericError:
            return "genericError"
        case .validation(let data):
            return NetworkError.errorFrom(data: data)
        case .serverError(let data):
            if let data = data {
                return NetworkError.errorFrom(data: data)
            } else {
                return "genericError"
            }
        }
    }

    var errorDescription: String? {
        message
    }

    var description: String {
        message
    }

    var localizedDescription: String {
        message
    }
}
