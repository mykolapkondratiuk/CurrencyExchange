//
//  NetworkServiceImpl.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import Foundation
import Alamofire
import Promis
import UIKit

final class NetworkServiceImpl: NetworkService {

    // MARK: - Internal properties

    // MARK: - Private properties

    private static var session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        return Alamofire.Session(configuration: configuration)
    }()

    // MARK: - Initializable private properties

    // MARK: - Initializers

    init() {}

    // MARK: - Internal methods

    // MARK: - NetworkService

    func doRequest(_ request: NetworkServiceRequest) -> Future<Data> {
        let promise = Promise<Data>()

        return doRequest(
            request,
            promise: promise
        )
    }

    func doRequest(
        _ request: NetworkServiceRequest,
        promise: Promise<Data>
    ) -> Future<Data> {
        NetworkServiceImpl
            .session
            .request(
                request.url,
                method: request.method,
                parameters: request.httpBody,
                encoding: request.parameterEncoding,
                headers: request.httpHeaders
            )
            .responseData { response in
                self.handle(
                    responseData: response,
                    request: request,
                    promise: promise
                )
            }

        return promise.future
    }

    // MARK: - Private methods

    private func handle(
        responseData: AFDataResponse<Data>,
        request: NetworkServiceRequest,
        promise: Promise<Data>? = nil
    ) {
        var error: Error?
        switch responseData.response?.statusCode {
        case (200...204)?:
            promise?.setResult(responseData.data ?? Data())
        default:
            if let data = responseData.data {
                let err = NetworkError.serverError(data)
                let error = err
                promise?.setError(error)
            } else {
                let err: Error = responseData.error ?? NetworkError.genericError
                error = err
                promise?.setError(err)
            }
        }

        self.printForDebug(
            request,
            responseData: responseData.data,
            code: responseData.response?.statusCode,
            error: error
        )
    }

    private func printForDebug(
        _ request: NetworkServiceRequest,
        responseData: Data?,
        code: Int?,
        error: Error?
    ) {
        let requestURL = "\(request.method.rawValue): \(request.url.absoluteString)"
        let requestBody = request.httpBody.description
        let reqestHeaders = request.httpHeaders.description
        log.debug("\nURL:\n\(requestURL)\nBODY:\n\(requestBody)\nHEADERS:\n\(reqestHeaders)\n")
        if let data = responseData {
            let response = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            let responseData: String? = (response != nil) ? "\(response ?? [:])" : String(data: data, encoding: .utf8)
            log.debug("\nRESPONSE: (\(code ?? 0)): \(responseData ?? "")")
        } else {
            if let err = error {
                log.debug("\nRESPONSE: (\(code ?? 0)): \(err.localizedDescription)")
            } else {
                log.debug("\nRESPONSE: (\(code ?? 0)): NO RESPONSE BODY DATA OR ERROR")
            }
        }
    }
}
