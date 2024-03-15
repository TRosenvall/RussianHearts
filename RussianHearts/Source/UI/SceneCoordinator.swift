//
//  SceneCoordinator.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import UIKit

/// Conforms to the delegate function of all the modules and handles coordination logic
/// between scenes.
protocol SceneCoordinating:
    LaunchDelegate,
    MainMenuDelegate,
    NewGameDelegate,
    GameDelegate,
    HighscoresDelegate,
    RulesDelegate,
    FriendsDelegate,
    SettingsDelegate
{
    /// Start the app and route to the first module
    func start()

    func reset()
}

class SceneCoordinator: SceneCoordinating {

    // MARK: - Properties

    private let mainWindow: UIWindow
    private let moduleManager: ModuleManaging
    private var navController: UINavigationController

    // MARK: - Lifecycle

    init(window: UIWindow?) throws {
        guard let window else { throw SceneError.noAppWindowFound }
        self.mainWindow = window
        self.moduleManager = ModuleManager.sharedInstance
        self.navController = UINavigationController()
    }

    // MARK: - Conformance: SceneCoordinating

    func start() {
        Logger.default.log("Starting Coordinator")

        guard let module: (any LaunchHost) = moduleManager.retrieveModule(delegate: self)
        else { Logger.default.logFatal("Unable To Retrieve Launch Host") }

        Logger.default.log("Retrieved Launch Host From Manager")
        navController = UINavigationController(rootViewController: module)
        mainWindow.rootViewController = navController
        mainWindow.makeKeyAndVisible()
    }

    func reset() {
        navController.dismiss(animated: false)

        start()
    }

    // MARK: - Conformance: LaunchDelegate

    func routeToMainMenu(with entity: GameEntity?) {
        Logger.default.log("Routing To Main Menu")

        guard let module: (any MainMenuHost) = moduleManager.retrieveModule(delegate: self)
        else { return }

        do {
            let updatedModule = try module.with(entity)
            updatedModule.modalPresentationStyle = .fullScreen
            presentModule(updatedModule, animated: false)
        } catch {
            Logger.default.log("Error found while updating entity: \(error)")

            module.modalPresentationStyle = .fullScreen
            presentModule(module, animated: false)
        }
    }

    // MARK: - Conformance: MainMenuDelegate

    func routeToNewGame() {
        Logger.default.log("Routing To New Game")

        guard let module: (any NewGameHost) = moduleManager.retrieveModule(delegate: self)
        else { return }

        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    // MARK: - Conformance: NewGameDelegate

    func routeBack(animated: Bool) {
        dismissModule(animated: animated)
    }

    func routeToGame(with: GameEntity) {
        guard let module: (any GameView) = moduleManager.retrieveModule(delegate: self)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    // MARK: - Conformance: GameDelegate

    func routeBackToMainMenu(from module: any ModuleController) {
        navController.popToRootViewController(animated: false)

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

        for module in modulesToRelease {
            module.shouldRelease = true
            moduleManager.dismissReleasableModules()
        }
        routeToMainMenu(with: nil)
    }

    func routeToHighScores() {
        guard let module: (any HighscoresView) = moduleManager.retrieveModule(delegate: self)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func routeToRules() {
        guard let module: (any RulesView) = moduleManager.retrieveModule(delegate: self)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func routeToFriends() {
        guard let module: (any FriendsView) = moduleManager.retrieveModule(delegate: self)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    func routeToSettings() {
        guard let module: (any SettingsView) = moduleManager.retrieveModule(delegate: self)
        else { return }
        module.modalPresentationStyle = .fullScreen
        presentModule(module, animated: true)
    }

    // MARK: - Helpers

    private func presentModule(_ module: any ModuleController, animated: Bool) {
        navController.pushViewController(module, animated: animated)
    }

    private func dismissModule(animated: Bool) {
        let viewController = navController.popViewController(animated: animated)
        guard let module = viewController as? (any ModuleController)
        else { return }
        module.shouldRelease = true
        moduleManager.dismissReleasableModules()
    }
}
