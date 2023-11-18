//
//  GameContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/1/23.
//

import UIKit

protocol GameView: ModuleView {
    var presenter: GamePresenting? { get set }
}

protocol GamePresenting: ModulePresenting {
    var view: (any GameView)? { get set }
    var interactor: GameInput? { get set }

    func getPlayer() -> PlayerModel

    func getPlayers() -> [PlayerModel]

    func endTurn(cardPlayed: Card?) -> EndTurnType

    func getPlayedCards() -> [Card]

    func routeToMainMenu()

    func routeToHighScores()

    func getPlayerIdForFirstPlayerThisPhase() -> Int?

    func getTrump() -> CardSuit?
}

// Called on by presenter to do peices of work
protocol GameInput: ModuleInput {
    var output: GameOutput? { get set }
    
    func getActivePlayer() -> PlayerModel
    
    func getAllPlayers() -> [PlayerModel]
    
    func endTurn(cardPlayed: Card?) -> EndTurnType

    func getPlayedCards() -> [Card]

    func getPlayerIdForFirstPlayerThisPhase() -> Int?

    func getTrump() -> CardSuit?
}

// Determines what to do with final interactor results
protocol GameOutput: ModuleOutput {
    var delegate: GameDelegate { get set }
}

// Determines how to call on required dependencies for routing
protocol GameDelegate: ModuleDelegate {
    func routeToMainMenu()

    func routeToHighScores()
}
