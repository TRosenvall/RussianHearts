//
//  DeckController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/15/23.
//

import Foundation

enum DeckError: Error {
    case shuffleFailed
    case incorrectNumberOfCards
    case duplicateCardFound
    case cardNotInStack
}

// All these functions should return a deck controller
struct DeckController: Model {

    // MARK: - Properties
    let id: UUID
    let cards: Deck

    // MARK: - Lifecycle
    internal init(with base: DeckController?, id: UUID?) {
        do {
            try self.init(base: base, id: id)
        } catch {
            // Should never hit, means the cards aren't initializing correctly.
            fatalError(error.localizedDescription)
        }
    }

    /// This should only be initialized once without passing in a base or cards. Otherwise the card
    /// comparisons will all fail.
    fileprivate init(base: DeckController? = nil,
                     id: UUID? = nil,
                     cards: Deck? = nil) throws {
        self.id = id ?? base?.id ?? UUID()
        self.cards = try cards ?? base?.cards ?? {

            var drawPile: [Card] = []

            for value in CardValue.allCases {
                for suit in CardSuit.allCases {
                    let card = try NumberCard.Builder.with(suit: suit).with(value: value).build().wrap()
                    drawPile.append(card)
                }
            }

            for type in SpecialCardType.allCases {
                let card = try SpecialCard.Builder.with(type: type).build().wrap()
                drawPile.append(card)
            }

            guard drawPile.count == 60
            else { throw DeckError.incorrectNumberOfCards }

            return try Deck.Builder.with(drawPile: drawPile).with(discardPile: []).build()
        }()
    }

    // MARK: - Helpers

    // No need to validate here
    func validate() throws -> DeckController {
        return self
    }

    /// Removes the first instance of a card from the draw pile. Throws if the drawpile is nil or
    /// if the card isn't in the stack.
    func removeCardFromDrawPile(card: Card) async throws -> DeckController {
        guard let drawPile = cards.drawPile,
              let trump = cards.trump,
              let discardPile = cards.discardPile
        else { throw ModelError.requiredModelPropertiesNotSet(onType: [Card].self) }

        guard drawPile.contains(card: card),
              let index = drawPile.firstIndex(of: card)
        else { throw DeckError.cardNotInStack }

        let newDrawPile = drawPile.removeAt(index)

        let newDeck = try Deck.Builder.with(drawPile: newDrawPile)
                                      .with(trump: trump)
                                      .with(discardPile: discardPile)
                                      .build()
        return try DeckController.Builder.with(cards: newDeck).build()
    }

    /// Checks if the card is already in the discard and draw pile. If not, puts the card
    /// in the discard pile
    func putCardInDiscardPile(card: Card) async throws -> DeckController {
        guard let discardPile = cards.discardPile,
              let drawPile = cards.drawPile,
              let trump = cards.trump
        else { throw ModelError.requiredModelPropertiesNotSet(onType: [Card].self) }

        let totalCardsInDeck = drawPile + discardPile

        guard !totalCardsInDeck.contains(card: card)
        else { throw DeckError.duplicateCardFound }

        let newDiscardPile = discardPile + [card]

        let newDeck = try Deck.Builder.with(drawPile: drawPile)
                                      .with(trump: trump)
                                      .with(discardPile: newDiscardPile)
                                      .build()
        return try DeckController.Builder.with(cards: newDeck).build()
    }

    /// Puts all the cards from the discard pile back into the draw pile. Should only be
    /// called after each round meaning every card should either be in the draw pile or
    /// in the discard pile.
    func resetDeck() async throws -> DeckController {
        guard let shuffledDiscardPile = cards.discardPile?.shuffled(),
              let currentDrawPile = cards.drawPile
        else { throw DeckError.shuffleFailed }

        let newDrawPile = currentDrawPile + shuffledDiscardPile

        guard newDrawPile.count == 60
        else { throw DeckError.incorrectNumberOfCards }

        let newDeck = try Deck.Builder.with(drawPile: newDrawPile)
                                      .with(discardPile: [])
                                      .build()
        return try DeckController.Builder.with(cards: newDeck).build()
    }

    /// Sets the trump suit property on the deck. May reset the deck to do so. Will throw if it
    /// finds anumber card without the suit properly set.
    func getNewTrump() async throws -> DeckController {
        guard let numberCards = cards.drawPile?.compactMap({ $0.unwrapNumberCard() })
        else {
            let newDeck = try await resetDeck()
            return try await newDeck.getNewTrump()
        }

        guard let newTrumpCard = numberCards.first,
              let newTrumpSuit = newTrumpCard.suit,
              let discardPile = cards.discardPile
        else { throw ModelError.requiredModelPropertiesNotSet(onType: CardSuit.self) }

        let newDrawPile = numberCards.dropFirst().compactMap({ $0.wrap() })
        let newDiscardPile = discardPile + [newTrumpCard.wrap()]

        let newDeck = try Deck.Builder.with(drawPile: newDrawPile)
                                      .with(trump: newTrumpSuit)
                                      .with(discardPile: newDiscardPile)
                                      .build()
        return try DeckController.Builder.with(cards: newDeck).build()
    }
}

// MARK: - Builder Extension
extension GenericBuilder where T == DeckController {
    func with(cards: Deck) throws -> GenericBuilder<DeckController> {
        let newBase = try DeckController(base: base, cards: cards)
        return GenericBuilder<DeckController>(base: newBase)
    }
}
