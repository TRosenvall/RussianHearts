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
    var interactor: MainMenuInput?

    var delegate: MainMenuDelegate?

    var shouldEnableContinueButton: Bool {
        if let interactor {
            return interactor.gameFound
        }
        return false
    }

    // MARK: - Lifecycle
    init(delegate: MainMenuDelegate) {
        self.delegate = delegate
    }

    // MARK: - Conformance: MainMenuPresenting
    func routeToNewGameModule() {
        delegate?.routeToNewGameModule()
    }
    
    func routeToGameModule() {
        // TODO
    }
    
    func routeToHighScoreModule() {
        delegate?.routeToHighscoresModule()
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
