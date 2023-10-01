//
//  GamePresenter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/1/23.
//

import Foundation

class GamePresenter: GamePresenting {

    // MARK: - Properties
    var view: (any GameView)?
    var router: GameWireframe?
    var interactor: GameInput?

    // MARK: - Lifecycle
    init() {}

    // MARK: - Conformance: GamePresenting
    func getPlayer() -> PlayerModel {
        guard let interactor
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return interactor.getActivePlayer()
    }

    func getPlayers() -> [PlayerModel] {
        guard let interactor
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return interactor.getAllPlayers()
    }

    func endTurn(cardPlayed: Card?) -> EndTurnType {
        guard let interactor
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return interactor.endTurn(cardPlayed: cardPlayed)
    }

    func routeToMainMenu() {
        router?.routeToMainMenu()
    }

    func routeToHighScores() {
        router?.routeToHighScores()
    }

    func getPlayedCards() -> [Card] {
        return interactor!.getPlayedCards()
    }
}
