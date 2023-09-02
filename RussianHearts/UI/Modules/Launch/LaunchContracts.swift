//
//  LaunchContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import Foundation

protocol LaunchView: ModuleView {
    var presenter: LaunchPresenting? { get set }
}

protocol LaunchPresenting: ModulePresenting {
    var view: (any LaunchView)? { get set }
    var router: LaunchWireframe? { get set }
    var interactor: LaunchInput? { get set }

    func launchApp()
}

// Called on by presenter to do peices of work
protocol LaunchInput: ModuleInput {
    var output: LaunchOutput? { get set }

    func loadData(from type: DataStorageType) throws
}

// Determines what to do with final interactor results
protocol LaunchOutput: ModuleOutput {
    func routeToMainApplication()
}

// Determines where to reach out to and how to call delegate functions
protocol LaunchWireframe: ModuleWireframe {
    var delegate: LaunchDelegate { get set }

    func routeToMainApplication()
}

// Determines how to call on required dependencies for routing
protocol LaunchDelegate: ModuleDelegate {
    func routeToMainApplication()
}
