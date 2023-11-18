//
//  MainMenuContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

protocol MainMenuView: ModuleView {
    var presenter: MainMenuPresenting? { get set }
}

protocol MainMenuPresenting: ModulePresenting {
    var view: (any MainMenuView)? { get set }
    var interactor: MainMenuInput? { get set }

    var shouldEnableContinueButton: Bool { get }

    /// Routes to the new game module
    func routeToNewGameModule()

    /// Routes to the game module with a saved game
    func routeToGameModule()

    /// Routes to the high score module
    func routeToHighScoreModule()

    /// Routes to the rules modules
    func routeToRulesModule()

    /// Routes to the friend module
    func routeToFriendModule()

    /// Routes to the settings module
    func routeToSettingsModule()
}

protocol MainMenuInput: ModuleInput {
    var output: MainMenuOutput? { get set }

    var gameFound: Bool { get }
}

protocol MainMenuOutput: ModuleOutput {
    var delegate: MainMenuDelegate? { get set }
}

protocol MainMenuDelegate: ModuleDelegate {
    func routeToNewGameModule()

    func routeToHighscoresModule()
}
