//
//  GameService.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

class GameService: Service {

    // MARK: - Properties
    let entityManager: EntityManaging

    var games: [GameModel] {
        get {
            do {
                if let gameEntity: GameEntity = try entityManager.retrieveEntity() {
                    guard let savedGames = gameEntity.savedGames
                    else {
                        print("No saved games available")
                        return []
                    }
                    return savedGames
                }
            } catch {
                print("Unable to find saved games.")
            }
            return []
        }
        set {
            do {
                if let gameEntity: GameEntity = try entityManager.retrieveEntity() {
                    gameEntity.savedGames = newValue
                    try entityManager.update(entity: gameEntity)
                }
            } catch {
                do {
                    let gameEntity = GameEntity(savedGames: newValue)
                    try entityManager.save(entity: gameEntity)
                } catch {
                    print("Unable to save games")
                }
            }
        }
    }

    var foundGame: Bool {
        return !games.isEmpty
    }

    private var _activeGame: GameModel?
    var activeGame: GameModel? {
        get {
            // Return the stored active game
            return _activeGame
        }
        set {
            // Check if an existing game of that id exists
            let index = games.firstIndex { game in
                if let _activeGame {
                    return game.id == _activeGame.id
                }
                return false
            }
            // Remove the existing game
            if let index {
                games.remove(at: index)
            }
            // Refresh the game with the updated value if it exists. If no value exists,
            // the game is finished and will be removed from the games array which should
            // be reflected in the saved games file.
            if let newValue {
                games.append(newValue)
            }
            self._activeGame = newValue
        }
    }

    var deck: DeckModelController

    var playerThatWonLastRound: PlayerModel?

    // MARK: - Lifecycle
    init(entityManager: EntityManaging = EntityManager.shared,
         deck: DeckModelController = DeckModelController()) {
        self.entityManager = entityManager
        self.deck = deck
    }

    // MARK: - Conformance: Service

    // MARK: - Helpers

    // Game Model Controller
    // Removes game data
    func resetGame() {
        activeGame = nil
    }

    // Create a new game
    func newGame(with players: [PlayerModel]) {
        activeGame = GameModel(players: players)
        deck.newRound(in: &activeGame!)
    }

    func nextRound(in game: inout GameModel) -> EndTurnType {
        let currRound = game.activeRound
        if currRound != game.rounds.last {
            let index = game.rounds.firstIndex(of: currRound)
            game.activeRound = game.rounds[index! + 1]
            deck.newRound(in: &game)
            return .roundEnd
        } else {
            game.endOfGame = true
            return .gameEnd
        }
    }

    func moveCardFromHandToPlayAreaFromPlayer(card: Card, playerHand stack: inout [Card]) {
        deck.newTurn(card: card, stack: &stack)
    }

    func nextPhase(in game: inout GameModel) -> EndTurnType {
        scorePhase()
        deck.newPhase()
        let currPhase = game.activeRound.activePhase
        if currPhase != game.activeRound.phases.last {
            let index = game.activeRound.phases.firstIndex(of: currPhase)
            game.activeRound.activePhase = game.activeRound.phases[index! + 1]
            return .phaseEnd
        } else {
            return nextRound(in: &game)
        }
    }

    func nextTurn(in game: inout GameModel) -> EndTurnType {
        let currTurn = game.activeRound.activePhase.activeTurn
        if currTurn != game.activeRound.activePhase.turns.last {
            let index = game.activeRound.activePhase.turns.firstIndex(of: currTurn)
            game.activeRound.activePhase.activeTurn = game.activeRound.activePhase.turns[index! + 1]
            return .turnEnd
        } else {
            return nextPhase(in: &game)
        }
    }

    func isLastTurn(in phase: PhaseModel) -> Bool {
        let currTurn = phase.activeTurn
        if currTurn == phase.turns.last {
            return true
        }
        return false
    }

    func scorePhase() {
        let cardsPlayed = deck.getCardsInPlay()
        guard let players = activeGame?.players else { return }

        for card in cardsPlayed {
            for player in players where card.playedByPlayerWithId == player.id {
                print("=====")
                print("Player: \(player.name)")
                if let card = card as? NumberCard {
                    print("Card Value: \(card.value)")
                    print("Card Suit: \(card.suit)")
                }
                if let card = card as? SpecialCard {
                    print("Card Suit: \(card.type)")
                }
                print("")
            }
        }

        let trump: CardSuit = deck.getTrump().suit
        var winningCard: Card?

        for card in cardsPlayed {
            if winningCard == nil {
                winningCard = card
            }
        }

        for player in players where player.id == winningCard?.playedByPlayerWithId {
            self.playerThatWonLastRound = player
        }

        getNextPhaseOrder()
    }

    func getNextPhaseOrder() {
        let players = self.activeGame?.players.sorted(using: $0.id < $1.id)
        
        
    }
}
