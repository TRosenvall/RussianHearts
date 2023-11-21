//
//  ModuleContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import UIKit

///------ Below is the breakdown of a module

/// Handles how the module is dismissed.
protocol ModuleDelegate: AnyObject {}

/// Handles any business logic associated with the module
protocol ModuleWorker: AnyObject {}

/// Contains all the UI elements for the module
protocol MainView: UIView {
    func setupViews()
}

/// Handles presentation directions for the modules MainView
protocol ModuleController: UIViewController, Equatable {
    var module: Module { get }
}

extension ModuleController {
    static var moduleType: String {
        return "\(Self.self)"
    }

    static func == (lhs: any ModuleController, rhs: any ModuleController) -> Bool {
        return lhs.module.id == rhs.module.id
    }
}
