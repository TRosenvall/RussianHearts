//
//  PlayerModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import Foundation

class Player {
    var cards: [Card]
    var name: String
    var activeBid: Bid?
    var wonBids: [Bid]
    var lostBids: [Bid]
    var score: Int

    init(cards: [Card] = [],
         name: String,
         activeBid: Bid? = nil,
         wonBids: [Bid] = [],
         lostBids: [Bid] = [],
         score: Int = 0) {
        self.cards = cards
        self.name = name
        self.activeBid = activeBid
        self.wonBids = wonBids
        self.lostBids = lostBids
        self.score = score
    }
}
