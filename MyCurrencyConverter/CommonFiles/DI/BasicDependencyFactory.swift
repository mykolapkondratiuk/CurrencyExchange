//
//  BasicDependencyFactory.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.09.2022.
//

import Foundation

class BasicDependencyFactory<Dependency>: DependencyFactory {
    
    // MARK: - Private properties
    
    private var dependency: Dependency?
    
    // MARK: - Initializable private properties
    
    private let factory: (Resolver) -> Dependency

    // MARK: - Initializers
    init(_ factory: @escaping (Resolver) -> Dependency) {
        self.factory = factory
    }
    
    // MARK: - Internal methods
    
    func resolve(_ resolver: Resolver) -> Dependency {
        if let resolved = dependency {
            return resolved
        }
        
        let resolved = factory(resolver)
        self.dependency = resolved
        
        return resolved
    }
}
