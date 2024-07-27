//
//  CardProtocol+Impl.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import UIKit

protocol CardProtocol: Model {

    // MARK: - Properties
    var playedBy: Player? { get }
}

enum Card: Codable, Equatable {
    case number(card: NumberCard)
    case special(card: SpecialCard)

    func unwrapSpecialCard() -> SpecialCard? {
        switch self {
        case .number:
            return nil
        case .special(let card):
            return card
        }
    }

    func unwrapNumberCard() -> NumberCard? {
        switch self {
        case .number(let card):
            return card
        case .special:
            return nil
        }
    }
}

extension Array where Element == Card {

    /// Returns whether or not an array of cards contains a card or now.
    func contains(card: Card) -> Bool {
        return self.contains { element in
            isSame(card1: element, card2: card)
        }
    }

    /// Returns the first index of a card within an array of cards.
    func firstIndex(of card: Card) -> Int? {
        return self.firstIndex { element in
            isSame(card1: element, card2: card)
        }
    }

    /// Compares two cards to see if they're the same
    private func isSame(card1: Card, card2: Card) -> Bool {
        if card1.unwrapNumberCard() == card2.unwrapNumberCard() {
            return true
        }
        if card1.unwrapSpecialCard() == card2.unwrapSpecialCard() {
            return true
        }
        return false
    }
}
