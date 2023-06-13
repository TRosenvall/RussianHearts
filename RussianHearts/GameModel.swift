//
//  GameModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

// Number of cards to play is the raw value
enum RoundOrder: Int {
    case roundOne = 7
    case roundTwo = 5
    case roundThree = 3
    case roundFour = 1
    case roundFive = 2
    case roundSix = 4
    case roundSeven = 6
}

class Model {
    var activeRound: RoundOrder
    var players: [Player]
    var deck: [Card]
    var trump: Card
    var discard: [Card]

    init(activeRound: RoundOrder,
         players: [Player],
         deck: [Card],
         trump: Card,
         discard: [Card]) {
        self.activeRound = activeRound
        self.players = players
        self.deck = deck
        self.trump = trump
        self.discard = discard
    }
}
