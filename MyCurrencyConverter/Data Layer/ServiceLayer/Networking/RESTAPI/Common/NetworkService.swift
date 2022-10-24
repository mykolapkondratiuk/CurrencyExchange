//
//  NetworkService.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import Foundation
import Alamofire
import Promis
import UIKit

protocol NetworkService {
    /// Method for work with NetworkServiceRequest & Future<Data>
    /// - Parameters:
    /// - request: instance of NetworkServiceRequest
    func doRequest(_ request: NetworkServiceRequest) -> Future<Data>

    /// Method for work with NetworkServiceRequest & Future<Data>
    /// - Parameters:
    /// - request: instance of NetworkServiceRequest
    /// - promise: instance of Promise<Data>
    func doRequest(
        _ request: NetworkServiceRequest,
        promise: Promise<Data>
    ) -> Future<Data>
}
