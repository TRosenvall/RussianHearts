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

    var playerIdForFirstPlayerThisPhase: Int = 1

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
        scoreRound()
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
        let winningId = scorePhase()
        deck.newPhase()
        let currPhase = game.activeRound.activePhase
        if currPhase != game.activeRound.phases.last {
            let index = game.activeRound.phases.firstIndex(of: currPhase)
            game.activeRound.activePhase = game.activeRound.phases[index! + 1]
            game.activeRound.activePhase.firstPlayerId = winningId
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

    func scorePhase() -> Int? {
        guard let players = activeGame?.players else { return nil }

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
        let specialCards: [SpecialCard] = filteredSpecialCards.compactMap { $0 as? SpecialCard }

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

        return getNextPhaseOrder(winningCard: winningCard)
    }

    func getNextPhaseOrder(winningCard: Card?) -> Int? {
        // If there is no winning card, phase order shouldn't be updated.
        guard let winningCard else { return nil }

        // Get the players
        guard var players = self.activeGame?.players
        else { fatalError("No players found") }

        // Sort players by id from smallest to greatest
        players = players.sorted { $0.id < $1.id }

        // Rotate the players array till the winning id is the first one.
        let winningId = winningCard.playedByPlayerWithId
        while players.first?.id != winningId {
            rotate(players: &players)
        }

        // If the first player id matches the winning card, then the player order is now correct
        guard let winningPlayer = players.first else { return nil }

        playerIdForFirstPlayerThisPhase = winningPlayer.id
        winningPlayer.score += 1
        print("Starting player name: \(winningPlayer.name.description)")
        return winningPlayer.id
    }

    func getPlayerIdForFirstPlayerThisPhase() -> Int {
        return playerIdForFirstPlayerThisPhase
    }

    // New
    func getLargestPlayerId() -> Int {
        guard let playersById = activeGame?.players.sorted(by: { $0.id < $1.id }),
              let lastPlayersId = playersById.last?.id
        else {
            fatalError("No active game")
        }

        return lastPlayersId
    }

    func getSuitPlayedFirst() -> CardSuit? {
        // If the first player didn't play a number card, we need to keep checking other players.
        let lastPlayersId = getLargestPlayerId()

        // Get the cards played, and the person who played first in the phase
        let cardsPlayed = deck.getCardsInPlay()
        var currentIdToCheck = getPlayerIdForFirstPlayerThisPhase()

        // We'll use a mod operator to loop player ids once we reach the end.
        var hasLoopedPlayerIds = false
        // Break the while loop when we've hit every player
        while !hasLoopedPlayerIds {
            // Get the number cards played by the current player we're checking.
            let cardsPlayedByCurrentlyCheckedPlayer = cardsPlayed.filter { card in
                return card.playedByPlayerWithId == currentIdToCheck
            }.map { card in
                return card as? NumberCard
            }

            // If there is one, we need to return it's suit.
            if let foundCard = cardsPlayedByCurrentlyCheckedPlayer.first,
               let foundSuit = foundCard?.suit {
                return foundSuit
            }

            // If there isn't one, we need to check the next players id
            currentIdToCheck += 1

            /// playerId = 2 lastPlayerId = 5; 2 % 5 = 2
            /// playerId = 3 lastPlayerId = 5; 3 % 5 = 3
            /// playerId = 4 lastPlayerId = 5; 4 % 5 = 4
            /// playerId = 5 lastPlayerId = 5; 5 % 5 = 0
            /// playerId = 1 lastPlayerId = 5; 1 % 5 = 1
            /// playerId = 2 lastPlayerId = 5; 2 % 5 = 2
            /// playerId = 3 lastPlayerId = 5; 3 % 5 = 3
            // This should properly update the id we're checking.
            if currentIdToCheck % lastPlayersId != 0 {
                currentIdToCheck = currentIdToCheck % lastPlayersId
            }

            // If we're hitting this id again, then we've looped and need to break out of the loop.
            if currentIdToCheck == getPlayerIdForFirstPlayerThisPhase() {
                hasLoopedPlayerIds = true
            }
        }

        // No number card has been played yet.
        return nil
    }
    
    func playerHasSuitInHand(_ player: PlayerModel, suit: CardSuit) -> Bool {
        let numberCards = player.cards.compactMap { card in
            return card as? NumberCard
        }
        let cardSuits = numberCards.map { $0.suit }
        return cardSuits.contains(suit)
    }

    func isSuit(for card: NumberCard,
                suit: CardSuit) -> Bool {
        deck.cardIsSuit(for: card, suit: suit)
    }

    func scoreRound() {
        guard let players = activeGame?.players else { return }

        for player in players {
            let bidValue = player.activeBid?.value
            let score = player.score

            if bidValue == score {
                player.scoreTotal += (score + 10)
            }

            player.activeBid = nil
            player.score = 0
        }
    }
}
