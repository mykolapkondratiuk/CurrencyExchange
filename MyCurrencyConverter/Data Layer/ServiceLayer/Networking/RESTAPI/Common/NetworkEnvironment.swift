//
//  NetworkEnvironment.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

enum NetworkEnvironment: String, CaseIterable {

    case develop = "dev"
    case testing = "qa"
    case staging = "stg"
    case preprod = "preprod"

    var serviceURL: String {
        switch self {
        case .develop:
            return "http://api.evp.lt/currency/commercial/exchange/"
        case .testing:
            return "http://api.evp.lt/currency/commercial/exchange/"
        case .preprod:
            return "http://api.evp.lt/currency/commercial/exchange/"
        case .staging:
            return "http://api.evp.lt/currency/commercial/exchange/"
        }
    }

    static var allCases: [NetworkEnvironment] {
        [.develop, .testing, .staging, .preprod]
    }

    private static var initial: NetworkEnvironment = {
        #if DEBUGMODE
            return .develop
        #elseif TESTINGMODE
            return .testing
        #else
            return .staging
        #endif
    }()

    static var current: NetworkEnvironment {
        get {
            guard let env = NetworkEnvironment(rawValue: UserDefaultsStorage.networkEnvironment) else {
                UserDefaultsStorage.networkEnvironment = initial.rawValue
                return initial
            }

            return env
        }
        set {
            UserDefaultsStorage.networkEnvironment = newValue.rawValue
        }
    }

    static func setWith(host: String?) -> Bool {
        switch host {
        case Self.develop.webHost:
            NetworkEnvironment.current = .develop
        case Self.testing.webHost:
            NetworkEnvironment.current = .testing
        case Self.staging.webHost:
            NetworkEnvironment.current = .staging
        case Self.preprod.webHost:
            NetworkEnvironment.current = .preprod
        default:
            return false
        }
        return true
    }

    private var webHost: String {
        switch self {
        case .develop:
            return "api.evp.lt/currency/commercial/exchange"
        case .testing:
            return "api.evp.lt/currency/commercial/exchange"
        case .preprod:
            return "api.evp.lt/currency/commercial/exchange"
        case .staging:
            return "api.evp.lt/currency/commercial/exchange"
        }
    }

    var webAppURL: String {
        return "https://\(webHost)/"
    }
}
