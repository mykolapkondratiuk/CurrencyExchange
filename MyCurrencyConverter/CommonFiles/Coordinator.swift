//
//  Coordinator.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.09.2022.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var delegate: Coordinator? { get set }

    func start()
    func didStop(coordinator: Coordinator)
}

extension Coordinator {
    func didStop(coordinator: Coordinator) {
        removeChild(coordinator: coordinator)
    }

    func addChild(coordinator: Coordinator) {
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        // start added coordinator
        coordinator.start()
    }

    func removeChild(coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
}
