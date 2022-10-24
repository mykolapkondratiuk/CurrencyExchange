//
//  Container.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.09.2022.
//

import Foundation

enum ContainerError: Error, CustomStringConvertible {
    case dependencyNotFound(String)
    case dependencyDublicate(String)

    var description: String {
        switch self {
        case .dependencyNotFound(let dependency):
            return "\(dependency) not found, please register it before use"
        case .dependencyDublicate(let dependency):
            return "\(dependency) dublicated, please remove it"
        }
    }
}

/// Dependency Injection Container
class Container: Resolver, CustomDebugStringConvertible {

    // MARK: - Internal properties

    // MARK: - CustomDebugStringConvertible

    var debugDescription: String {
        return "\(self.factories)"
    }

    // MARK: - Initializable private properties
    private let parent: Container?
    private var factories: Set<AnyDependencyFactory>

    // MARK: - Initializers

    init(parent: Container? = nil) {
        self.parent = parent
        self.factories = []
    }

    private init(
        parent: Container?,
        factories: Set<AnyDependencyFactory>
    ) {
        self.parent = parent
        self.factories = factories
    }

    // MARK: - Internal methods

    // MARK: - Resolver

    /// Resolve dependency
    /// - Parameters:
    /// - type: injecting dependency type
    func resolve<Dependency>(_ type: Dependency.Type) throws -> Dependency {
        if let factory = factories.first(where: { $0.supports(type) }) {
            return factory.resolve(self)
        } else if let parent = parent {
            return try parent.resolve(type)
        }

        throw ContainerError.dependencyNotFound("\(type)")
    }

    /// Registers dependency
    /// - Parameters:
    /// - type: dependency type
    /// - instance: dependency instance
    @discardableResult
    func register<Dependency>(
        _ type: Dependency.Type,
        instance: Dependency
    ) throws -> Container {
        return try register(type) { _ in instance }
    }

    /// Register dependency
    /// - Parameters:
    /// - type: dependency type
    /// - factory:  dependency factory method
    @discardableResult
    func register<Dependency>(
        _ type: Dependency.Type,
        _ factory: @escaping (Resolver) -> Dependency
    ) throws -> Container {
        guard !factories.contains(where: { $0.supports(type) }) else {
            throw ContainerError.dependencyDublicate("\(type)")
        }

        let newFactory = BasicDependencyFactory<Dependency> { factory($0) }
        factories.insert(AnyDependencyFactory(newFactory))

        return self
    }
}
