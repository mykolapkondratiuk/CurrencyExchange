//
//  Resolver.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.09.2022.
//

protocol Resolver {
    /// Retrieves the instance with the specified dependency type.
    /// - Parameters:
    ///  - type: The dependency type to retrieve.
    /// - Returns: The dependency instance
    func resolve<Dependency>(_ type: Dependency.Type) throws -> Dependency
}

extension Resolver {
    /// Retrieves the instance with the specified dependency type.
    /// If the specified dependency not found it will be produce a crash.
    /// - Parameters:
    ///  - type: The dependency type to retrieve.
    /// - Returns: The dependency instance
    func required<Dependency>(_ type: Dependency.Type) -> Dependency {
        guard let component = try? resolve(type) else {
            fatalError("First you need to register the dependency \(Dependency.self)")
        }
        
        return component
    }
}
