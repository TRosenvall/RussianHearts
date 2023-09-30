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
    var router: GameWireframe? { get set }
    var interactor: GameInput? { get set }

    func getPlayer() -> PlayerModel

    func getPlayers() -> [PlayerModel]

    func endTurn(cardPlayed: Card?) -> EndTurnType

    func routeToMainMenu()

    func routeToHighScores()
}

// Called on by presenter to do peices of work
protocol GameInput: ModuleInput {
    var output: GameOutput? { get set }
    
    func getActivePlayer() -> PlayerModel
    
    func getAllPlayers() -> [PlayerModel]
    
    func endTurn(cardPlayed: Card?) -> EndTurnType
}

// Determines what to do with final interactor results
protocol GameOutput: ModuleOutput {}

// Determines where to reach out to and how to call delegate functions
protocol GameWireframe: ModuleWireframe {
    var delegate: GameDelegate { get set }

    func routeToMainMenu()

    func routeToHighScores()
}

// Determines how to call on required dependencies for routing
protocol GameDelegate: ModuleDelegate {
    func routeToMainMenu()

    func routeToHighScores()
}
