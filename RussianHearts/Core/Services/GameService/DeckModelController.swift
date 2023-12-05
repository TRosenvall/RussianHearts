//
//  DeckModelController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/15/23.
//

import Foundation

class DeckModelController {
    // MARK: - Properties
    var deck: DeckModel

    // MARK: - Lifecycle
    init(deck: DeckModel? = nil) {
        var cards: [Card] = []

        CardValues.allCases.forEach { value in
            CardSuit.allCases.forEach { suit in
                cards.append(NumberCard(value: value,
                                        suit: suit))
            }
        }

        SpecialCardType.allCases.forEach { type in
            cards.append(SpecialCard(type: type))
        }
        
        assert(cards.count == 60, "Deck Did Not Build, \(cards.count)")

        self.deck = deck ?? DeckModel(cards: cards)
    }

    // MARK: - Helpers
    func newRound(in game: inout GameModel) {
        // Move all cards in discard pile back to main deck
        for card in self.deck.discardPile {
            moveCardFromOneStackIntoAnother(card: card,
                                            stack1: &self.deck.discardPile,
                                            stack2: &self.deck.cards)
        }

        // Move all cards in all players hands back to deck
        for player in game.players {
            for card in player.cards {
                moveCardFromOneStackIntoAnother(card: card,
                                                stack1: &player.cards,
                                                stack2: &self.deck.cards)
            }
        }

        for card in deck.cardsInPlay {
            moveCardFromOneStackIntoAnother(card: card,
                                            stack1: &self.deck.cardsInPlay,
                                            stack2: &self.deck.cards)
        }

        // Shuffle the deck
        self.deck.cards.shuffle()

        // Deal the cards to all the players
        dealCards(to: &game.players, on: &game.activeRound)

        // Get the trump card for the round
        game.activeRound.trump = getNewTrump()
        print("==")
        print("Trump: \(game.activeRound.trump)")
    }

    func moveCardFromTopIntoDeck() {
        // Pull the top card, put it into the back of the deck and shuffle
        let topCard: Card = self.deck.cards.remove(at: 0)
        self.deck.cards.append(topCard)
        self.deck.cards.shuffle()

        // Check the top card again, if they match, repeat.
        let topCardSecondPass: Card = self.deck.cards.remove(at: 0)
        if topCard == topCardSecondPass {
            moveCardFromTopIntoDeck()
        }
    }

    func moveCardFromOneStackIntoAnother(card: Card,
                                         stack1: inout [Card],
                                         stack2: inout [Card]) {
        // Get the index of the card to be removed
        let index = stack1.firstIndex { cardToRemove in
            
            // Check if the card is a numberCard
            if let numCard = card as? NumberCard,
               let numToRemove = cardToRemove as? NumberCard {
                return numCard.value == numToRemove.value && numCard.suit == numToRemove.suit
            }
            
            // Check if the card is a specialCard
            if let specCard = card as? SpecialCard,
               let specToRemove = cardToRemove as? SpecialCard {
                return specCard.type == specToRemove.type
            }
            
            // Return false if neither, this will happen if the card isn't in the stack passed in.
            return false
        }
        
        // If the index exists, remove it from the stack and add it to the discard pile
        if let index {
            stack1.remove(at: index)
            stack2.append(card)
        }
    }

    func newTurn(card: Card, stack: inout [Card]) {
        moveCardFromOneStackIntoAnother(card: card,
                                        stack1: &stack,
                                        stack2: &self.deck.cardsInPlay)
    }

    func newPhase() {
        for card in self.deck.cardsInPlay {
            moveCardFromOneStackIntoAnother(card: card,
                                            stack1: &self.deck.cardsInPlay,
                                            stack2: &self.deck.discardPile)
        }
    }

    func discard(card: Card, stack: inout [Card]) {
        moveCardFromOneStackIntoAnother(card: card,
                                        stack1: &stack,
                                        stack2: &self.deck.discardPile)
    }

    func dealCards(to players: inout [PlayerModel],
                   on round: inout RoundModel) {
        for _ in 0..<round.numberOfCardsToPlay {
            for player in players {
                if let topCard: Card = self.deck.cards.first {
                    moveCardFromOneStackIntoAnother(card: topCard,
                                                    stack1: &self.deck.cards,
                                                    stack2: &player.cards)
                }
            }
        }

        for player in players {
            organizeHand(for: player)
        }
    }

    func getTrump() -> CardSuit {

        if let trump = deck.trump {
            return trump
        }

        let numberCards: [NumberCard] = self.deck.cards.compactMap { card in
            return card as? NumberCard
        }

        if let firstNumberCard = numberCards.first {
            deck.trump = firstNumberCard.suit
            return firstNumberCard.suit
        } else {
            for card in deck.discardPile {
                moveCardFromOneStackIntoAnother(card: card,
                                                stack1: &deck.discardPile,
                                                stack2: &deck.cards)
            }
            return getTrump()
        }
    }

    func getNewTrump() -> CardSuit {
        deck.trump = nil
        return getTrump()
    }

    func getCardsInPlay() -> [Card] {
        return deck.cardsInPlay
    }

    func cardIsSuit(for card: NumberCard,
                    suit: CardSuit?) -> Bool {
        if let suit {
            return card.suit == suit
        }
        return false
    }

    func organizeHand(for player: PlayerModel) {
        var numberCards = player.cards.compactMap { $0 as? NumberCard }
        var specialCards = player.cards.compactMap { $0 as? SpecialCard }
        
        var redCards: [NumberCard] = []
        var blueCards: [NumberCard] = []
        var brownCards: [NumberCard] = []
        var purpleCards: [NumberCard] = []
        
        for card in numberCards {
            if card.suit == .red {
                redCards.append(card)
            }
            if card.suit == .blue {
                blueCards.append(card)
            }
            if card.suit == .brown {
                brownCards.append(card)
            }
            if card.suit == .purple {
                purpleCards.append(card)
            }
        }
        
        redCards = redCards.sorted(by: { $0.value.rawValue < $1.value.rawValue })
        blueCards = blueCards.sorted(by: { $0.value.rawValue < $1.value.rawValue })
        brownCards = brownCards.sorted(by: { $0.value.rawValue < $1.value.rawValue })
        purpleCards = purpleCards.sorted(by: { $0.value.rawValue < $1.value.rawValue })
        
        numberCards = redCards + blueCards + brownCards + purpleCards
        
        var lowCard: SpecialCard?
        var highCard: SpecialCard?
        var lowJoker: SpecialCard?
        var highJoker: SpecialCard?
        for card in specialCards where card.type == .lowCard {
            lowCard = card
        }
        for card in specialCards where card.type == .highCard {
            highCard = card
        }
        for card in specialCards where card.type == .lowJoker {
            lowJoker = card
        }
        for card in specialCards where card.type == .highJoker {
            highJoker = card
        }
        
        specialCards = []
        if let lowCard {
            specialCards.append(lowCard)
        }
        if let highCard {
            specialCards.append(highCard)
        }
        if let lowJoker {
            specialCards.append(lowJoker)
        }
        if let highJoker {
            specialCards.append(highJoker)
        }

        player.cards = numberCards + specialCards
    }
}
