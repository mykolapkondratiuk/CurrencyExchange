//
//  CurrencyConverterCoordinator.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import UIKit

final class CurrencyConverterCoordinator: Coordinator {

    // MARK: - Internal properties

    // MARK: - Coordinator

    var childCoordinators: [Coordinator] = []
    weak var delegate: Coordinator?

    // MARK: - Private properties

    private let currencyConverterViewController: CurrencyConverterViewController
    private let currencyConverterViewModel: CurrencyConverterViewModel

    private let rootViewController: UIViewController

    // MARK: - Initializable private properties

    private let window: UIWindow
    private let container: Resolver

    // MARK: - Initializers

    init(
        window: UIWindow,
        container: Resolver
    ) {
        self.window = window
        self.container = container
         
        let commissionManager = CommissionManagerImpl()
        let viewModel = CurrencyConverterViewModel(
            container: container,
            commissionManager: commissionManager
        )
        self.currencyConverterViewController = CurrencyConverterViewController(viewModel: viewModel)
        self.currencyConverterViewModel = viewModel

        self.rootViewController = UINavigationController(rootViewController: currencyConverterViewController)

        window.rootViewController = rootViewController
    }

    // MARK: - Coordinator

    func start() {
        window.makeKeyAndVisible()
    }
}
