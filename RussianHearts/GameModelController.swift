//
//  GameModelController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/14/23.
//

import Foundation

let Game = GameModelController.shared
class GameModelController {

    static let shared = GameModelController()

    var activeGame: GameModel? = nil

    init() {}

    func resetGame() {
        activeGame = nil
    }

    func newGame(with players: [Player]) {
        Deck.newGame()
        activeGame = GameModel(players: players,
                               deck: Deck.deckModel.cards)
    }
}
