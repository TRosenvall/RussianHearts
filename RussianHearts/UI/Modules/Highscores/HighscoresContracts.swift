//
//  HighscoresContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/19/23.
//

import Foundation

protocol HighscoresView: ModuleView {
    var presenter: HighscoresPresenting? { get set }
}

protocol HighscoresPresenting: ModulePresenting {
    var view: (any HighscoresView)? { get set }
    var router: HighscoresWireframe? { get set }
    var interactor: HighscoresInput? { get set }

    func backButtonTapped()
}

// Called on by presenter to do peices of work
protocol HighscoresInput: ModuleInput {
    var output: HighscoresOutput? { get set }
}

// Determines what to do with final interactor results
protocol HighscoresOutput: ModuleOutput {}

// Determines where to reach out to and how to call delegate functions
protocol HighscoresWireframe: ModuleWireframe {
    var delegate: HighscoresDelegate { get set }

    func routeToMainMenu()
}

// Determines how to call on required dependencies for routing
protocol HighscoresDelegate: ModuleDelegate {
    func routeToMainMenu()
}
