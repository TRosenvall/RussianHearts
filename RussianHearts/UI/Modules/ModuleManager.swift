//
//  ModuleManager.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import Foundation

class ModuleManager: ModuleManaging {

    // MARK: - Properties
    var factory: ModuleWorks
    
    var resolvedModules: [any ModuleView]

    // MARK: - Lifecycle
    init() {
        self.factory = ModuleFactory()
        self.resolvedModules = []
    }

    // MARK: - Conformance: ModuleManaging
    func retrieveModule<T>(delegate: SceneCoordinating) -> T? {
        for module in resolvedModules where module is T {
            return module as? T
        }
        let module: T? = factory.buildModule(delegate: delegate)
        guard let resolvedModule = module as? any ModuleView
        else { return nil }
        self.resolvedModules.append(resolvedModule)
        return module
    }

    func dismiss(module: any ModuleView) {
        guard let index = resolvedModules.firstIndex(where: { $0.id == module.id })
        else { return }
        resolvedModules.remove(at: index)
    }

}
