//
//  ModuleContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import UIKit

/// Keeps modules and dismisses them when needed. Requests new modules when needed
protocol ModuleManaging {

    /// The factory used in resolving modules
    var factory: ModuleFactory { get set }

    /// Already resolved modules get stored here until dismissed
    var resolvedModules: [any ModuleView] { get set }

    /// Calls upon the factory to resolve additional modules if they don't exist
    func retrieveModule<T>(delegate: SceneCoordinating) -> T?

    /// Removes and returns a module from the resolvedModules array
    func dismiss(module: any ModuleView)
}

/// Holds all dependencies required for building new modules. Instantiates builders as needed
protocol ModuleFactory {

    /// Builds and returns a module of a given type
    func buildModule<T>(delegate: SceneCoordinating) -> T?

}

///------ Below is the breakdown of a module

/// Contains all the UI elements
protocol ModuleView: UIViewController, Equatable {
    var id: UUID { get }
}

extension ModuleView {
    static var moduleType: String {
        return "\(Self.self)"
    }

    static func == (lhs: any ModuleView, rhs: any ModuleView) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Handles all the UI interactions
protocol ModulePresenting {}

/// Handles any business logic associated with the module
protocol ModuleInput {}

/// Handles the results of the business logic
protocol ModuleOutput {}

/// Handles how the modules is dismissed.
protocol ModuleDelegate {}
