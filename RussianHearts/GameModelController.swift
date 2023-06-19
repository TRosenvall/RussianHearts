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
    var players: [PlayerModel] = []
    var endOfGame: Bool = false
    
    init() {}
    
    func resetGame() {
        activeGame = nil
        players = []
        endOfGame = false
    }
    
    func newGame(with players: [PlayerModel]) {
        self.players = players
        activeGame = GameModel()
        Deck.newRound()
    }
    
    func nextRound() {
        let currRound = Round.activeRound
        if currRound != activeGame?.rounds.last {
            let index = activeGame!.rounds.firstIndex(of: currRound!)
            activeGame?.activeRound = activeGame!.rounds[index! + 1]
            Deck.newRound()
        } else {
            endOfGame = true
        }
    }
}
