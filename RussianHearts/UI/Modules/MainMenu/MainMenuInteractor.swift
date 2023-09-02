//
//  MainMenuInteractor.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

class MainMenuInteractor: MainMenuInput {

    // MARK: - Properties
    var output: MainMenuOutput?

    var gameFound: Bool {
        guard let gameService: GameService = ServiceManager.shared.retrieveService() else {
            return false
        }
        return gameService.foundGame
    }

    // MARK: - Lifecycle

    // MARK: - Conformance: MainMenuInput

    // MARK: - Helpers
}
