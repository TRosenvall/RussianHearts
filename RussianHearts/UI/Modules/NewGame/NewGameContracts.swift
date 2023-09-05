//
//  NewGameContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

protocol NewGameView: ModuleView {
    var presenter: NewGamePresenting? { get set }
}

protocol NewGamePresenting: ModulePresenting {
    var view: (any NewGameView)? { get set }
    var router: NewGameWireframe? { get set }
    var interactor: NewGameInput? { get set }

    func backButtonTapped()

    func startNewGame(with playerValues: [Int?: String?])
}

// Called on by presenter to do peices of work
protocol NewGameInput: ModuleInput {
    var output: NewGameOutput? { get set }

    func startNewGame(with playerValues: [Int?: String?])
}

// Determines what to do with final interactor results
protocol NewGameOutput: ModuleOutput {
    func routeToGameModule()
}

// Determines where to reach out to and how to call delegate functions
protocol NewGameWireframe: ModuleWireframe {
    var delegate: NewGameDelegate { get set }

    func backButtonTapped()

    func routeToGameModule()
}

// Determines how to call on required dependencies for routing
protocol NewGameDelegate: ModuleDelegate {
    func routeBack(animated: Bool)

    func routeToGameModule()
}
