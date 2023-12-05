//
//  SceneRouter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import UIKit

class SceneRouter: SceneWireframe {

    // MARK: - Properties
    let mainWindow: UIWindow
    var navController: UINavigationController?
    let manager: ModuleManaging
    var delegate: SceneCoordinating?

    // MARK: - Lifecycle
    init(window: UIWindow) {
        self.mainWindow = window
        self.manager = ModuleManager()
    }

    // MARK: - Conformance: SceneWireframe
    func routeToLaunchModule() {
        guard let delegate,
              let module: (any LaunchView) = manager.retrieveModule(delegate: delegate)
        else { return }
        navController = UINavigationController(rootViewController: module)
        navController?.isNavigationBarHidden = true
        mainWindow.rootViewController = navController
        mainWindow.makeKeyAndVisible()
    }

    func routeToMainMenu() {
        guard let delegate,
              let module: (any MainMenuView) = manager.retrieveModule(delegate: delegate)
        else {
            return
        }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: false)
    }

    func routeToNewGameModule() {
        guard let delegate,
              let module: (any NewGameView) = manager.retrieveModule(delegate: delegate)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func routeToGameModule() {
        guard let delegate,
              let module: (any GameView) = manager.retrieveModule(delegate: delegate)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func routeBackToMainMenu(from module: any ModuleController) {
        navController?.popToRootViewController(animated: false)

        var modulesToRelease: [any ModuleController] = []
        var moduleToCheck = module
        while moduleToCheck != mainWindow.rootViewController {
            modulesToRelease.append(moduleToCheck)
            if let moduleController = moduleToCheck.presentingViewController as? (any ModuleController) {
                moduleToCheck = moduleController
            } else {
                break
            }
        }

        for release in modulesToRelease {
            manager.dismiss(module: release)
        }
//        manager.dismiss(module: module)
        routeToMainMenu()
    }

    func routeToHighScores() {
        guard let delegate,
              let module: (any HighscoresView) = manager.retrieveModule(delegate: delegate)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func routeToRules() {
        guard let delegate,
              let module: (any RulesView) = manager.retrieveModule(delegate: delegate)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func routeToFriends() {
        guard let delegate,
              let module: (any FriendsView) = manager.retrieveModule(delegate: delegate)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func routeToSettings() {
        guard let delegate,
              let module: (any SettingsView) = manager.retrieveModule(delegate: delegate)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func dismiss(animated: Bool) {
        dismissModule(animated: animated)
    }

    // MARK: - Helper
    func presentModule(_ module: any ModuleController, animated: Bool) {
        navController?.pushViewController(module, animated: animated)
    }

    func dismissModule(animated: Bool) {
        let viewController = navController?.popViewController(animated: animated)
        guard let module = viewController as? (any ModuleController)
        else { return }
        manager.dismiss(module: module)
    }
}
