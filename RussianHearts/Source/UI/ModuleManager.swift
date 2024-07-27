//
//  ModuleManager.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import Foundation

/// Keeps modules and dismisses them when needed. Requests new modules when needed
protocol ModuleManaging {

    /// The factory used in resolving modules
    var factory: ModuleFactory { get }

    /// Already resolved modules get stored here until dismissed
    var resolvedModules: [any ModuleController] { get set }

    /// Calls upon the factory to resolve additional modules if they don't exist
    func retrieveModule<T>(delegate: SceneCoordinating?, gameEntity: GameEntity?) -> T?

    /// Removes all modules which are no longer required
    func dismissReleasableModules()
}

extension ModuleManaging {
    func retrieveModule<T>(delegate: SceneCoordinating? = nil) -> T? {
        let module: T? = retrieveModule(delegate: delegate, gameEntity: nil)
        return module
    }
}

class ModuleManager: ModuleManaging {

    // MARK: - Properties
    static var sharedInstance: ModuleManaging = ModuleManager()

    let factory: ModuleFactory
    var resolvedModules: [any ModuleController]

    // MARK: - Lifecycle
    init() {
        self.factory = ModuleFactoryImpl()
        self.resolvedModules = []
    }

    // MARK: - Conformance: ModuleManaging
    func retrieveModule<T>(delegate: SceneCoordinating? = nil, gameEntity: GameEntity? = nil) -> T? {
        Logger.default.log("Retrieving Module Of Type: - \(T.self)")

        dismissReleasableModules()
        if let delegate {
            let module: T? = resolveModule(delegate: delegate, gameEntity: gameEntity)
            return module
        }
        let module: T? = returnModuleIfAvailable()
        return module
    }

    func dismissReleasableModules() {
        Logger.default.log("Dismissing Releasable Modules")

        for module in resolvedModules where module.shouldRelease == true {
            dismiss(module: module)
        }
    }

    // MARK: - Helpers

    private func dismiss(module: any ModuleController) {
        Logger.default.log("Dismissing \(module)")

        guard let index = resolvedModules.firstIndex(where: { $0.module.id == module.module.id })
        else { return }
        let module = resolvedModules.remove(at: index)
        module.navigationController?.popViewController(animated: false)
    }

    private func returnModuleIfAvailable<T>() -> T? {
        Logger.default.log("Ensuring Module Of Type \(T.self) Loaded Correctly")

        for module in resolvedModules where module is T {
            Logger.default.log("Returning Loaded Module Of Type \(T.self)")
            return module as? T
        }

        return nil
    }

    private func resolveModule<T>(delegate: SceneCoordinating, gameEntity: GameEntity? = nil) -> T? {
        Logger.default.log("Resolving Module Of Type: \(T.self)")

        guard let module: T = factory.buildModule(delegate: delegate, gameEntity: gameEntity)
        else {
            Logger.default.log("Unable to Build Module Of Type: \(T.self)")
            return nil
        }

        guard let module = module as? (any ModuleController)
        else {
            Logger.default.log("Module Of Type \(T.self) Has No Controller")
            return nil
        }

        self.resolvedModules.append(module)
        return module as? T
    }
}
