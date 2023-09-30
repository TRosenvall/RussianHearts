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
    var cardsInPlay: [Card]

    init(cards: [Card],
         discardPile: [Card] = [],
         cardsInPlay: [Card] = []) {
        self.cards = cards
        self.discardPile = discardPile
        self.cardsInPlay = cardsInPlay
    }
}
