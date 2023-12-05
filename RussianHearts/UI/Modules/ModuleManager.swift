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
    var factory: ModuleFactory { get set }

    /// Already resolved modules get stored here until dismissed
    var resolvedModules: [any ModuleController] { get set }

    /// Calls upon the factory to resolve additional modules if they don't exist
    func retrieveModule<T>(delegate: SceneCoordinating) -> T?

    /// Removes and returns a module from the resolvedModules array
    func dismiss(module: any ModuleController)
}

class ModuleManager: ModuleManaging {

    // MARK: - Properties
    var factory: ModuleFactory
    
    var resolvedModules: [any ModuleController]

    // MARK: - Lifecycle
    init() {
        self.factory = ModuleFactoryImpl()
        self.resolvedModules = []
    }

    // MARK: - Conformance: ModuleManaging
    func retrieveModule<T>(delegate: SceneCoordinating) -> T? {
//        for module in resolvedModules where module is T {
//            return module as? T
//        }
        let module: T? = factory.buildModule(delegate: delegate)
        guard let resolvedModule = module as? any ModuleController
        else { return nil }
        self.resolvedModules.append(resolvedModule)
        return module
    }

    func dismiss(module: any ModuleController) {
        guard let index = resolvedModules.firstIndex(where: { $0.module.id == module.module.id })
        else { return }
        resolvedModules.remove(at: index)
    }

}
