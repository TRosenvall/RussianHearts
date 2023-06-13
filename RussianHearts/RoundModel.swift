//
//  RoundModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

class Round {
    var numberOfCardsToPlay: Int
    var bidsByPlayer: [(bid: Bid, player: Player)]
    var playersByTurnOrder: [(player: Player, turnOrder: Int)]
    var activeTurn: Turn
    var cardsPlayedByPlayer: [(card: Card, player: Player)]

    init(numberOfCardsToPlay: Int,
         bidsByPlayer: [(bid: Bid, player: Player)],
         playersByTurnOrder: [(player: Player, turnOrder: Int)],
         activeTurn: Turn,
         cardsPlayedByPlayer: [(card: Card, player: Player)]) {
        self.numberOfCardsToPlay = numberOfCardsToPlay
        self.bidsByPlayer = bidsByPlayer
        self.playersByTurnOrder = playersByTurnOrder
        self.activeTurn = activeTurn
        self.cardsPlayedByPlayer = cardsPlayedByPlayer
    }
}
