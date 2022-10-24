//
//  DependencyFactory.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.09.2022.
//

protocol DependencyFactory {
    associatedtype Dependency
    
    func resolve(_ resolver: Resolver) -> Dependency
}
