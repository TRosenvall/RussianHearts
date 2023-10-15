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

    var playerIdForFirstPlayerThisPhase: Int? = 0

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
    var cardsPlayed: [Card] {
        deck.getCardsInPlay()
    }
    var filteredNumberCards: [Card] {
        cardsPlayed.filter { $0 is NumberCard }
    }

    var numberCards: [NumberCard] {
        filteredNumberCards.map { $0 as! NumberCard}
    }

    var firstCardSuit: CardSuit? {
        numberCards.first?.suit
    }

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

        let trump: CardSuit = deck.getTrump()

        var winningCard: Card?

        let filteredSpecialCards: [Card] = cardsPlayed.filter { $0 is SpecialCard }
        let specialCards: [SpecialCard] = filteredSpecialCards.map { $0 as! SpecialCard }

        var hasHighJoker: Bool = false
        var hasLowJoker: Bool = false
        var hasHighCard: Bool = false
        var hasLowCard: Bool = false

        for card in specialCards {
            if card.type == .highJoker {
                hasHighJoker = true
            } else if card.type == .lowJoker {
                hasLowJoker = true
            } else if card.type == .highCard {
                hasHighCard = true
            } else if card.type == .lowCard {
                hasLowCard = true
            }
        }

        print("=======")
        print("Has High Joker: \(hasHighJoker)")
        print("Has Low Joker: \(hasLowJoker)")
        print("Has High Card: \(hasHighCard)")
        print("Has Low Card: \(hasLowCard)")
        print("")

        if (hasLowCard && hasHighCard) || (!hasLowCard && !hasHighCard) {
            // Get a winning card
            for card in cardsPlayed {
                if winningCard == nil {
                    winningCard = card
                }
            }

            // Make the winning card the first color card
            for card in cardsPlayed {
                if let card = card as? NumberCard,
                   let currWinning = winningCard as? NumberCard {
                    if card.suit == firstCardSuit && currWinning.suit != firstCardSuit {
                        winningCard = card
                    }
                }
            }

            // Make the winning card the highest first color card
            for card in cardsPlayed {
                if let card = card as? NumberCard,
                   let currWinning = winningCard as? NumberCard {
                    if card.suit == firstCardSuit && card.value.rawValue > currWinning.value.rawValue  {
                        winningCard = card
                    }
                }
            }

            // Make the winning card the trump card
            for card in cardsPlayed {
                if let card = card as? NumberCard,
                   let currWinning = winningCard as? NumberCard {
                    if card.suit == trump && currWinning.suit != trump {
                        winningCard = card
                    }
                }
            }

            // Make the winning card the highest trump card
            for card in cardsPlayed {
                if let card = card as? NumberCard,
                   let currWinning = winningCard as? NumberCard {
                    if card.suit == trump && card.value.rawValue > currWinning.value.rawValue  {
                        winningCard = card
                    }
                }
            }

            if hasLowJoker {
                for specialCard in specialCards where specialCard.type == .lowJoker {
                    winningCard = specialCard
                }
            }

            if hasHighJoker {
                for specialCard in specialCards where specialCard.type == .highJoker {
                    winningCard = specialCard
                }
            }
        }

        if hasHighCard {
            // Make the winning card the highest value
            for card in cardsPlayed {
                if let card = card as? NumberCard,
                   let currWinning = winningCard as? NumberCard {
                    if card.value.rawValue > currWinning.value.rawValue {
                        winningCard = card
                    }
                }
            }

            if hasLowJoker {
                for specialCard in specialCards where specialCard.type == .lowJoker {
                    winningCard = specialCard
                }
            }

            if hasHighJoker {
                for specialCard in specialCards where specialCard.type == .highJoker {
                    winningCard = specialCard
                }
            }
        }

        if hasLowCard {
            // Make the winning card the highest value
            for card in cardsPlayed {
                if let card = card as? NumberCard,
                   let currWinning = winningCard as? NumberCard {
                    if card.value.rawValue < currWinning.value.rawValue {
                        winningCard = card
                    }
                }
            }
        }

        for player in players where player.id == winningCard?.playedByPlayerWithId {
            self.playerThatWonLastRound = player
        }

        let winningCardsPlayerId = winningCard?.playedByPlayerWithId
        print("=========")
        print("Round won by:")
        for player in players where player.id == winningCardsPlayerId {
            print(player.name)
        }
        print("")
        print("--=-=--")

        getNextPhaseOrder(winningCard: winningCard)
    }

    func getNextPhaseOrder(winningCard: Card?) {
        var players = self.activeGame?.players.sorted { $0.id < $1.id }

        if let winningCard {
            while players?[0].id != winningCard.playedByPlayerWithId {
                guard let removedPlayer = players?.remove(at: 0) else { fatalError("Can't initialize game without players.") }
                players?.append(removedPlayer)
            }
        }

        playerIdForFirstPlayerThisPhase = players?[0].id
        print("Starting player name: \(players?[0].name)")
    }

    func getPlayerIdForFirstPlayerThisPhase() -> Int? {
        return playerIdForFirstPlayerThisPhase
    }
}
