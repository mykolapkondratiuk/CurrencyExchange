//
//  AppDelegate.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.09.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Private properties

    private (set) var appCoordinator: AppCoordinator?

    // MARK: - Life Cycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupAppearance()
        startAppCoordinator()

        return true
    }

    // MARK: - Private methods

    private func setupAppearance() {
        // Customize appearance UILabel, UITextField, UIBarButtonItem & etc...

        UINavigationBar.appearance().tintColor = UIColor(
            red: 0,
            green: 120 / 255.0,
            blue: 199 / 255.0,
            alpha: 1
        )

        UINavigationBar.appearance().backgroundColor = UIColor(
            red: 0,
            green: 120 / 255.0,
            blue: 199 / 255.0,
            alpha: 1
        )
    }

    private func startAppCoordinator() {
        appCoordinator = AppCoordinator()
        self.window = appCoordinator?.window
        appCoordinator?.start()
    }
}
