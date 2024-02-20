//
//  ModuleContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import UIKit
import SwiftUI

///------ Below is the breakdown of a module

/// Handles how the module is dismissed.
protocol ModuleDelegate: AnyObject {}

///------

/// Handles telling the view how and what to present
protocol ModuleViewModel: Model {
    associatedtype UIEvent
    associatedtype ModuleError
    associatedtype UIRoute
    associatedtype ModuleState

    var uiRoutes: ((UIRoute) -> ())? { get }

    func handleUIEvent(_ event: UIEvent)

    func handleError(_ error: ModuleError)

    func getLatestState(completion: @escaping (ModuleState) -> ())
}

/// Contains all the UI elements for the module
protocol ModuleView: View {}

protocol ModuleTheme {}

/// Handles presentation directions for the modules MainView
protocol ModuleController: UIViewController, Equatable {
    var module: Module { get }
    var shouldRelease: Bool { get set }
}

extension ModuleController {
    static var moduleType: String {
        return "\(Self.self)"
    }

    static func == (lhs: any ModuleController, rhs: any ModuleController) -> Bool {
        return lhs.module.id == rhs.module.id
    }
}
