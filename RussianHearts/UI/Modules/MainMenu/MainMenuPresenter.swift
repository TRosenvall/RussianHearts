//
//  MainMenuPresenter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

class MainMenuPresenter: MainMenuPresenting, MainMenuOutput {

    // MARK: - Properties
    var view: (any MainMenuView)?
    var router: MainMenuWireframe?
    var interactor: MainMenuInput?

    var shouldEnableContinueButton: Bool {
        if let interactor {
            return interactor.gameFound
        }
        return false
    }

    // MARK: - Lifecycle

    // MARK: - Conformance: MainMenuPresenting
    func routeToNewGameModule() {
        router?.routeToNewGameModule()
    }
    
    func routeToGameModule() {
        // TODO
    }
    
    func routeToHighScoreModule() {
        router?.routeToHighscoresModule()
    }
    
    func routeToRulesModule() {
        // TODO
    }
    
    func routeToFriendModule() {
        // TODO
    }
    
    func routeToSettingsModule() {
        // TODO
    }

    // MARK: - Conformance: MainMenuOutput

    // MARK: - Helpers
}
