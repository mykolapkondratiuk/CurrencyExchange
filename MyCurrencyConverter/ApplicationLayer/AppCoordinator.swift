//
//  AppCoordinator.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.09.2022.
//

import UIKit

final class AppCoordinator: Coordinator {

    // MARK: - Internal properties

    let window: UIWindow
    let container: Resolver

    // MARK: Coordinator

    var childCoordinators: [Coordinator] = []
    weak var delegate: Coordinator?

    // MARK: - Initializers

    init() {
        container = AppContainer()
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }

    // MARK: - Internal methods

    // MARK: - Coordinator

    func start() {
        startCurrencyConverterCoordinator()
    }

    func didStop(coordinator: Coordinator) {
        removeChild(coordinator: coordinator)
    }

    // MARK: - Private methods

    func startCurrencyConverterCoordinator() {
        let currencyConverterCoordinator = CurrencyConverterCoordinator(
            window: window,
            container: container
        )

        addChild(coordinator: currencyConverterCoordinator)
    }
}
