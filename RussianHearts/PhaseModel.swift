//
//  PhaseModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/18/23.
//

import Foundation

class PhaseModel: Equatable {
    var turns: [TurnModel] = []
    var activeTurn: TurnModel
    var cardsPlayedByPlayer: [(card: Card, player: PlayerModel)]
    var id: Int

    init(players: [PlayerModel],
         id: Int) {
        self.cardsPlayedByPlayer = []

        for player in players {
            let turn = TurnModel(activePlayer: player)
            turns.append(turn)
        }

        self.activeTurn = turns.first!
        self.id = id
    }

    static func == (lhs: PhaseModel, rhs: PhaseModel) -> Bool {
        return lhs.id == rhs.id
    }
}
