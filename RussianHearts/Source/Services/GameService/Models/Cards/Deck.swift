//
//  Deck.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/15/23.
//

import Foundation

struct Deck: Model {

    // MARK: - Properties
    let id: UUID
    let drawPile: [Card]?
    let trump: CardSuit?
    let discardPile: [Card]?

    // MARK: - Lifecycle
    internal init(with base: Deck?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: Deck? = nil,
                     id: UUID? = nil,
                     drawPile: [Card]? = nil,
                     trump: CardSuit? = nil,
                     discardPile: [Card]? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.drawPile = drawPile ?? base?.drawPile
        self.trump = trump ?? base?.trump
        self.discardPile = discardPile ?? base?.discardPile
    }

    // MARK: - Helpers
    func validate() throws -> Deck {
        guard drawPile != nil, discardPile != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

// MARK: - Builder Extension
extension GenericBuilder where T == Deck {
    func with(drawPile: [Card]) -> GenericBuilder<Deck> {
        let newBase = Deck(base: base, drawPile: drawPile)
        return GenericBuilder<Deck>(base: newBase)
    }

    func with(trump: CardSuit) -> GenericBuilder<Deck> {
        let newBase = Deck(base: base, trump: trump)
        return GenericBuilder<Deck>(base: newBase)
    }

    func with(discardPile: [Card]) -> GenericBuilder<Deck> {
        let newBase = Deck(base: base, discardPile: discardPile)
        return GenericBuilder<Deck>(base: newBase)
    }
}
