//
//  DeckModelController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/15/23.
//

import Foundation

let Deck = DeckModelController.shared
class DeckModelController {
    
    static let shared = DeckModelController()
    var deckModel: DeckModel = DeckModel(cards: [])
    
    init() {
        self.deckModel.cards = []
        CardValues.allCases.forEach { value in
            CardSuit.allCases.forEach { suit in
                self.deckModel.cards.append(NumberCard(value: value,
                                                       suit: suit))
            }
        }
        
        SpecialCardType.allCases.forEach { type in
            self.deckModel.cards.append(SpecialCard(type: type))
        }
        
        assert(self.deckModel.cards.count == 60, "Deck Did Not Build, \(self.deckModel.cards.count)")
    }
    
    func newRound() {
        for card in self.deckModel.discardPile {
            moveCardFromOneStackIntoAnother(card: card,
                                            stack1: &self.deckModel.discardPile,
                                            stack2: &self.deckModel.cards)
        }

        for player in Game.players {
            for card in player.cards {
                moveCardFromOneStackIntoAnother(card: card,
                                                stack1: &player.cards,
                                                stack2: &self.deckModel.cards)
            }
        }

        self.deckModel.cards.shuffle()

        dealCards(players: &Game.players, round: Round.activeRound!)

        Round.activeRound?.trump = getTrump()
    }
    
    func moveCardFromTopIntoDeck() {
        let topCard: Card = self.deckModel.cards.remove(at: 0)
        self.deckModel.cards.append(topCard)
        self.deckModel.cards.shuffle()
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
    
    func discard(card: Card, stack: inout [Card]) {
        moveCardFromOneStackIntoAnother(card: card,
                                        stack1: &stack,
                                        stack2: &self.deckModel.discardPile)
    }

    func dealCards(players: inout [PlayerModel], round: RoundModel) {
        for _ in 0..<round.numberOfCardsToPlay {
            for player in players {
                let topCard: Card = self.deckModel.cards.first!
                moveCardFromOneStackIntoAnother(card: topCard,
                                                stack1: &self.deckModel.cards,
                                                stack2: &player.cards)
            }
        }
    }

    func getTrump() -> Card {
        var numberCard: Card? = nil
        for card in self.deckModel.cards {
            let specialCard = card as? SpecialCard
            if specialCard != nil {
                moveCardFromTopIntoDeck()
            } else {
                numberCard = card
                break
            }
        }
        return numberCard!
    }
}
