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
        guard let delegate else { return }
        let module: (any LaunchView)? = manager.retrieveModule(delegate: delegate)
        mainWindow.rootViewController = module
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

    func dismiss(animated: Bool) {
        dismissModule(animated: animated)
    }

    // MARK: - Helper
    func presentModule(_ module: any ModuleView, animated: Bool) {
        currentViewController?.present(module, animated: animated)
        currentViewController = module
    }

    func dismissModule(animated: Bool) {
        let parentViewController = currentViewController?.presentingViewController
        currentViewController?.dismiss(animated: animated)
        currentViewController = parentViewController
    }
}
