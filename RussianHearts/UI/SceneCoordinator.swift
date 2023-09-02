//
//  SceneCoordinator.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import UIKit

class SceneCoordinator: SceneCoordinating {

    // MARK: - Properties
    var router: SceneWireframe

    // MARK: - Lifecycle
    init(window: UIWindow? = UIApplication.shared.sceneDelegate.window) throws {
        guard let window else { throw SceneError.noAppWindowFound }
        self.router = SceneRouter(window: window)
        self.router.delegate = self
    }

    // MARK: - Conformance: SceneCoordinating
    func start() {
        router.routeToLaunchModule()
    }

    // MARK: - Conformance: LaunchDelegate
    func routeToMainApplication() {
        router.routeToMainMenu()
    }

    // MARK: - Conformance: MainMenuDelegate
    func routeToNewGameModule() {
        router.routeToNewGameModule()
    }

    // MARK: - Conformance: NewGameDelegate
    func routeBack(animated: Bool) {
        router.dismiss(animated: animated)
    }

    // MARK: - Helpers
}
