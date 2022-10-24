//
//  AnyDependenceFactory.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.09.2022.
//

final class AnyDependencyFactory: CustomDebugStringConvertible {
    // MARK: - Internal properties
    
    // MARK: - CustomDebugStringConvertible
    var debugDescription: String {
        return type
    }
    
    // MARK: - Private properties
    
    private let supports: (Any.Type) -> Bool
    private let type: String
    
    // MARK: - Initializable private properties
    
    private let resolve: (Resolver) -> Any
    
    // MARK: - Initializers
    
    /// Initializer dependency factory
    /// - Properties:
    /// - dependencyFactory:
    init<T: DependencyFactory>(_ dependencyFactory: T) {
        resolve = { resolver in
            dependencyFactory.resolve(resolver)
        }
        supports = { $0 == T.Dependency.self }
        type = "\(T.Dependency.self)"
    }
    
    /// Generic resolver for type Dependency
    /// - Properties:
    /// - resolver: resolver of this dependency with type Dependency
    func resolve <Dependency>(_ resolver: Resolver) -> Dependency {
        guard let dependency = resolve(resolver) as? Dependency else {
            assertionFailure("dependency is not resolved")
            return resolver.required(Dependency.self)
        }
        return dependency
    }
    
    func supports<Dependency>(_ type: Dependency.Type) -> Bool {
        return supports(type)
    }
}

extension AnyDependencyFactory: Hashable {
    static func == (
        lhs: AnyDependencyFactory,
        rhs: AnyDependencyFactory
    ) -> Bool {
        return lhs.debugDescription == rhs.debugDescription
    }
    
    func hash( into hasher: inout Hasher) {
        hasher.combine(debugDescription)
    }
}
