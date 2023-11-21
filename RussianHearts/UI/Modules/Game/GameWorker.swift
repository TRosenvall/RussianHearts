//
//  GameInteractor.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/1/23.
//

import Foundation

// Called on by presenter to do peices of work
protocol GameWorker: ModuleWorker {
    func getActivePlayer() -> PlayerModel
    
    func getAllPlayers() -> [PlayerModel]
    
    func endTurn(cardPlayed: Card?) -> EndTurnType

    func getPlayedCards() -> [Card]

    func getPlayerIdForFirstPlayerThisPhase() -> Int?

    func getTrump() -> CardSuit?
}

class GameWorkerImpl: GameWorker {

    // MARK: - Properties
    var serviceManager: ServiceManaging
    var gameService: GameService

    // MARK: - Lifecycle
    init(serviceManager: ServiceManaging = ServiceManager.shared) {
        self.serviceManager = serviceManager
        guard let gameService: GameService = serviceManager.retrieveService()
        else {
            fatalError("Game Service Not found")
        }
        self.gameService = gameService
    }

    // MARK: - Conformance: GameInput
    func getActivePlayer() -> PlayerModel {
        guard let activePlayer = gameService.activeGame?.activeRound.activePhase.activeTurn.activePlayer
        else {
            fatalError("No Player Found")
        }
        return activePlayer
    }

    func getAllPlayers() -> [PlayerModel] {
        guard let players = gameService.activeGame?.players
        else {
            fatalError("No Players Found")
        }
        return players
    }

    func endTurn(cardPlayed: Card?) -> EndTurnType {
        if let cardPlayed {
            gameService.moveCardFromHandToPlayAreaFromPlayer(card: cardPlayed,
                                                             playerHand: &getActivePlayer().cards)
        }
        let endTurnType = gameService.nextTurn(in: &(gameService.activeGame)!)
        if endTurnType == .roundEnd {
            let cardsInPlay = getPlayedCards()
            for card in cardsInPlay {
                card.playedByPlayerWithId = nil
            }
        }
        return endTurnType
    }

    func getPlayedCards() -> [Card] {
        return gameService.deck.getCardsInPlay()
    }

    func getPlayerIdForFirstPlayerThisPhase() -> Int? {
        return gameService.getPlayerIdForFirstPlayerThisPhase()
    }

    func getTrump() -> CardSuit? {
        return gameService.deck.getTrump()
    }
}
