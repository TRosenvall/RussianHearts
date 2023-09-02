//
//  DeckModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/15/23.
//

import Foundation

class DeckModel {
    var cards: [Card]
    var trump: CardSuit?
    var discardPile: [Card]

    init(cards: [Card],
         discardPile: [Card] = []) {
        self.cards = cards
        self.discardPile = discardPile
    }
}
