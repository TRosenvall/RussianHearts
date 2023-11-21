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
    var currentViewController: UIViewController?
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
        let navigationController = UINavigationController(rootViewController: module)
        navigationController.isNavigationBarHidden = true
        mainWindow.rootViewController = navigationController
        mainWindow.makeKeyAndVisible()
        currentViewController = mainWindow.rootViewController
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

    func routeBackToMainMenu() {
        currentViewController?.navigationController?.popToRootViewController(animated: false)
        currentViewController = mainWindow.rootViewController
        routeToMainMenu()
    }

    func routeToHighScores() {
        guard let delegate,
              let module: (any HighscoresView) = manager.retrieveModule(delegate: delegate)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func dismiss(animated: Bool) {
        dismissModule(animated: animated)
    }

    // MARK: - Helper
    func presentModule(_ module: any ModuleController, animated: Bool) {
        if currentViewController is UINavigationController {
            (currentViewController as? UINavigationController)?.pushViewController(module, animated: animated)
        } else {
            currentViewController?.navigationController?.pushViewController(module, animated: animated)
        }
        currentViewController = module
    }

    func dismissModule(animated: Bool) {
        guard let module = currentViewController as? (any ModuleController) else { return }
        let parentViewController = currentViewController?.presentingViewController
        manager.dismiss(module: module)
        currentViewController?.navigationController?.popViewController(animated: animated)
        currentViewController = parentViewController
    }
}
