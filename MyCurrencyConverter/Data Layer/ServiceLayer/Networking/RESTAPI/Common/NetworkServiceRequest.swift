//
//  NetworkServiceRequest.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import Foundation
import Alamofire
import Promis
import UIKit

protocol NetworkServiceRequest {
    var url: URL { get }

    var method: HTTPMethod { get }

    var parameterEncoding: ParameterEncoding { get }

    var httpHeaders: HTTPHeaders { get }

    var httpBody: [String: Any] { get }
}

extension NetworkServiceRequest {
    var method: HTTPMethod {
        return .get
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var httpBody: [String: Any] {
        return [:]
    }

    var httpHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers["Content-Type"] = "application/json"
        return headers
    }

    var baseURL: String {
        return "http://api.evp.lt/currency/commercial/exchange/"
    }
}
