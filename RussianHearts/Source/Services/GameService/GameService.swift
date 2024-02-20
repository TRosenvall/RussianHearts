//
//  GameService.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

///------

protocol GameServiceUseCase: UseCase {}

///------

/// All these functions should pull the latest game entity from the local store,
/// create a new entity in some way with modified properties from the pulled entity,
/// then persist it back to the local store.
struct GameService:
    Service
//    EndTurnDelegate,
//    EndTrickDelegate,
//    EndRoundDelegate,
//    StartNewGameDelegate
{

    // MARK: - Properties

    let id: UUID
    let useCase: CodingContainer? // Contains GameService.UseCase

    // MARK: - Lifecycle

    internal init(with base: GameService?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: GameService? = nil,
        id: UUID? = nil,
        useCase: GameService.UseCase? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.useCase = CodingContainer(useCase) ?? base?.useCase
    }

    // MARK: - Conformance: Model

    func validate() throws -> GameService {
        return self
    }

    // MARK: - Helpers

    func executeUseCase(
        for useCase: UseCaseType,
        withAccessor accessor: (any EntityAccessing)?,
        completion: ((UseCaseResultType) -> Void)? = nil
    ) throws {
        if let useCases = self.useCase?.value() as? GameService.UseCase {
            switch useCase {
            case .retrieveGameState:
                guard let retrieveGameState = useCases.retrieveGameState?.value() as? (any RetrieveGameStateUseCase)
                else { throw UseCaseError.useCaseNotFound }
                UseCaseManager.sharedInstance.execute(retrieveGameState, completion: completion)
            case .loadGame:
                print("TODO")
            case .endTurn:
                //            let useCaseImpl = EndTurn(delegate: self)
                //            useCaseManager.execute(useCaseImpl)
                print("TODO")
            case .endTrick:
                //            let useCaseImpl = EndTrick(delegate: self)
                //            useCaseManager.execute(useCaseImpl)
                print("TODO")
            case .endRound:
                //            let useCaseImpl = EndRound(delegate: self)
                //            useCaseManager.execute(useCaseImpl)
                print("TODO")
            case .startNewGame:
                //            let useCaseImpl = StartNewGame(delegate: self)
                //            useCaseManager.execute(useCaseImpl)
                print("TODO")
            }
        }
    }

//    var games: [GameModel] {
//        get {
//            do {
//                if let gameEntity: GameEntity = try entityManager.retrieveEntity() {
//                    guard let savedGames = gameEntity.savedGames
//                    else {
//                        print("No saved games available")
//                        return []
//                    }
//                    return savedGames
//                }
//            } catch {
//                print("Unable to find saved games.")
//            }
//            return []
//        }
//        set {
//            do {
//                if let gameEntity: GameEntity = try entityManager.retrieveEntity() {
//                    gameEntity.savedGames = newValue
//                    try entityManager.update(entity: gameEntity)
//                }
//            } catch {
//                do {
//                    let gameEntity = GameEntity(savedGames: newValue)
//                    try entityManager.save(entity: gameEntity)
//                } catch {
//                    print("Unable to save games")
//                }
//            }
//        }
//    }
//
//    var foundGame: Bool {
//        return !games.isEmpty
//    }
//
//    var playerIdForFirstPlayerThisPhase: Int = 1
//
//    private var _activeGame: GameState?
//    var activeGame: GameState? {
//        get {
//            // Return the stored active game
//            return _activeGame
//        }
//        set {
//            // Check if an existing game of that id exists
//            let index = games.firstIndex { game in
//                if let _activeGame {
//                    return game.id == _activeGame.id
//                }
//                return false
//            }
//            // Remove the existing game
//            if let index {
//                games.remove(at: index)
//            }
//            // Refresh the game with the updated value if it exists. If no value exists,
//            // the game is finished and will be removed from the games array which should
//            // be reflected in the saved games file.
//            if let newValue {
//                games.append(newValue)
//            }
//            self._activeGame = newValue
//        }
//    }
//    
//    var deck: DeckController
//    var cardsPlayed: [Card] {
//        deck.getCardsInPlay()
//    }
//    var filteredNumberCards: [Card] {
//        cardsPlayed.filter { $0 is NumberCard }
//    }
//
//    var numberCards: [NumberCard] {
//        filteredNumberCards.map { $0 as! NumberCard}
//    }
//
//    var firstCardSuit: CardSuit? {
//        numberCards.first?.suit
//    }
//
//    var playerThatWonLastRound: Player?
//
//    var endTurnType: EndTurnType = .roundEnd
//
//    // MARK: - Conformance: Service
//
//    // MARK: - Helpers
//
//    // Game Model Controller
//    // Removes game data
//    func resetGame() {
//        activeGame = nil
//    }
//
//    // Create a new game
//    func newGame(with players: [Player]) {
//        deck = DeckController()
//        activeGame = GameModel(players: players)
//        deck.newRound(in: &activeGame!)
//    }
//
//    func nextRound(in game: inout GameModel) -> EndTurnType {
//        scoreRound()
//        let currRound = game.activeRound
//        if currRound != game.rounds.last {
//            let index = game.rounds.firstIndex(of: currRound)
//            game.activeRound = game.rounds[index! + 1]
//            deck.newRound(in: &game)
//            resetPlayerCardStates(player: game.activeRound.activePhase.activeTurn.activePlayer)
//            self.endTurnType = .roundEnd
//            return self.endTurnType
//        } else {
//            game.endOfGame = true
//            self.endTurnType = .gameEnd
//            return self.endTurnType
//        }
//    }
//
//    func moveCardFromHandToPlayAreaFromPlayer(card: Card, playerHand stack: inout [Card]) {
//        deck.newTurn(card: card, stack: &stack)
//    }
//
//    func nextPhase(in game: inout GameModel) -> EndTurnType {
//        var winningId: Int? = nil
//
//        // Handle passing cards forward or backwards at the beginning of the phase.
//        if let passesForward = game.activeRound.activePhase.passesForward {
//            passCards(passesForward: passesForward)
//        } else {
//            // Otherwise, score normally
//            winningId = scorePhase()
//            deck.newPhase()
//        }
//
//        let currPhase = game.activeRound.activePhase
//        if currPhase != game.activeRound.phases.last {
//            let index = game.activeRound.phases.firstIndex(of: currPhase)
//            game.activeRound.activePhase = game.activeRound.phases[index! + 1]
//            game.activeRound.activePhase.firstPlayerId = winningId
//            resetPlayerCardStates(player: game.activeRound.activePhase.activeTurn.activePlayer)
//            self.endTurnType = .phaseEnd
//            return self.endTurnType
//        } else {
//            return nextRound(in: &game)
//        }
//    }
//
//    func nextTurn(in game: inout GameModel) -> EndTurnType {
//        let currTurn = game.activeRound.activePhase.activeTurn
//        if currTurn != game.activeRound.activePhase.turns.last {
//            let index = game.activeRound.activePhase.turns.firstIndex(of: currTurn)
//            game.activeRound.activePhase.activeTurn = game.activeRound.activePhase.turns[index! + 1]
//            resetPlayerCardStates(player: game.activeRound.activePhase.activeTurn.activePlayer)
//            self.endTurnType = .turnEnd
//            return self.endTurnType
//        } else {
//            return nextPhase(in: &game)
//        }
//    }
//
//    func isLastTurn(in phase: PhaseModel) -> Bool {
//        let currTurn = phase.activeTurn
//        if currTurn == phase.turns.last {
//            return true
//        }
//        return false
//    }
//
//    func scorePhase() -> Int? {
//        guard let players = activeGame?.players else { return nil }
//
//        for card in cardsPlayed {
//            for player in players where card.playedByPlayerWithId == player.id {
//                print("=====")
//                print("Player: \(player.name)")
//                if let card = card as? NumberCard {
//                    print("Card Value: \(card.value)")
//                    print("Card Suit: \(card.suit)")
//                }
//                if let card = card as? SpecialCard {
//                    print("Card Suit: \(card.type)")
//                }
//                print("")
//            }
//        }
//
//        let trump: CardSuit = deck.getTrump()
//
//        var winningCard: Card?
//
//        let filteredSpecialCards: [Card] = cardsPlayed.filter { $0 is SpecialCard }
//        let specialCards: [SpecialCard] = filteredSpecialCards.compactMap { $0 as? SpecialCard }
//
//        var hasHighJoker: Bool = false
//        var hasLowJoker: Bool = false
//        var hasHighCard: Bool = false
//        var hasLowCard: Bool = false
//
//        for card in specialCards {
//            if card.type == .highJoker {
//                hasHighJoker = true
//            } else if card.type == .lowJoker {
//                hasLowJoker = true
//            } else if card.type == .highCard {
//                hasHighCard = true
//            } else if card.type == .lowCard {
//                hasLowCard = true
//            }
//        }
//
//        print("=======")
//        print("Has High Joker: \(hasHighJoker)")
//        print("Has Low Joker: \(hasLowJoker)")
//        print("Has High Card: \(hasHighCard)")
//        print("Has Low Card: \(hasLowCard)")
//        print("")
//
//        // Get a winning card
//        for card in cardsPlayed {
//            if winningCard == nil && card is NumberCard {
//                winningCard = card
//            } else if winningCard == nil && card is SpecialCard {
//                winningCard = card
//            }
//        }
//
//        // No score should be incremented in the case of only the low card and high cards being played.
//        if cardsPlayed.count == 2 && hasLowCard && hasHighCard {
//            return playerThatWonLastRound?.id
//        }
//
//        if (hasLowCard && hasHighCard) || (!hasLowCard && !hasHighCard) {
//
//            // Make the winning card the first color card
//            for card in cardsPlayed {
//                if let card = card as? NumberCard,
//                   let currWinning = winningCard as? NumberCard {
//                    if card.suit == firstCardSuit && currWinning.suit != firstCardSuit {
//                        winningCard = card
//                    }
//                }
//            }
//
//            // Make the winning card the highest first color card
//            for card in cardsPlayed {
//                if let card = card as? NumberCard,
//                   let currWinning = winningCard as? NumberCard {
//                    if card.suit == firstCardSuit && card.value.rawValue > currWinning.value.rawValue  {
//                        winningCard = card
//                    }
//                }
//            }
//
//            // Make the winning card the trump card
//            for card in cardsPlayed {
//                if let card = card as? NumberCard,
//                   let currWinning = winningCard as? NumberCard {
//                    if card.suit == trump && currWinning.suit != trump {
//                        winningCard = card
//                    }
//                }
//            }
//
//            // Make the winning card the highest trump card
//            for card in cardsPlayed {
//                if let card = card as? NumberCard,
//                   let currWinning = winningCard as? NumberCard {
//                    if card.suit == trump && card.value.rawValue > currWinning.value.rawValue  {
//                        winningCard = card
//                    }
//                }
//            }
//
//            if hasLowJoker {
//                for specialCard in specialCards where specialCard.type == .lowJoker {
//                    winningCard = specialCard
//                }
//            }
//
//            if hasHighJoker {
//                for specialCard in specialCards where specialCard.type == .highJoker {
//                    winningCard = specialCard
//                }
//            }
//        } else if hasHighCard {
//            // Make the winning card the highest value
//            for card in cardsPlayed {
//                if let card = card as? NumberCard,
//                   let currWinning = winningCard as? NumberCard {
//                    if card.value.rawValue > currWinning.value.rawValue {
//                        winningCard = card
//                    }
//                }
//            }
//
//            if hasLowJoker {
//                for specialCard in specialCards where specialCard.type == .lowJoker {
//                    winningCard = specialCard
//                }
//            }
//
//            if hasHighJoker {
//                for specialCard in specialCards where specialCard.type == .highJoker {
//                    winningCard = specialCard
//                }
//            }
//        } else if hasLowCard {
//            // This might be the lowest card
//            if hasHighJoker {
//                for specialCard in specialCards where specialCard.type == .highJoker {
//                    winningCard = specialCard
//                }
//            }
//
//            if hasLowJoker {
//                for specialCard in specialCards where specialCard.type == .lowJoker {
//                    winningCard = specialCard
//                }
//            }
//
//            // Make the winning card the lowest value
//            for card in cardsPlayed {
//                if let card = card as? NumberCard,
//                   let currWinning = winningCard as? NumberCard {
//                    if card.value.rawValue < currWinning.value.rawValue {
//                        winningCard = card
//                    }
//                } else if let card = card as? NumberCard,
//                          let _ = winningCard as? SpecialCard {
//                    winningCard = card
//                }
//            }
//        }
//
//        for player in players where player.id == winningCard?.playedByPlayerWithId {
//            self.playerThatWonLastRound = player
//        }
//
//        let winningCardsPlayerId = winningCard?.playedByPlayerWithId
//        print("=========")
//        print("Round won by:")
//        for player in players where player.id == winningCardsPlayerId {
//            print(player.name)
//        }
//        print("")
//        print("--=-=--")
//
//        return getNextPhaseOrder(winningCard: winningCard)
//    }
//
//    func getNextPhaseOrder(winningCard: Card?) -> Int? {
//        // If there is no winning card, phase order shouldn't be updated.
//        guard let winningCard else { return nil }
//
//        // Get the players
//        guard var players = self.activeGame?.players
//        else { fatalError("No players found") }
//
//        // Sort players by id from smallest to greatest
//        players = players.sorted { $0.id < $1.id }
//
//        // Rotate the players array till the winning id is the first one.
//        let winningId = winningCard.playedByPlayerWithId
//        while players.first?.id != winningId {
//            rotate(players: &players)
//        }
//
//        // If the first player id matches the winning card, then the player order is now correct
//        guard let winningPlayer = players.first else { return nil }
//
//        playerIdForFirstPlayerThisPhase = winningPlayer.id
//        winningPlayer = PlayerBuilder(base: winningPlayer)
//                            .with(currentScore: winningPlayer.currentScore + 1)
//                            .build()
//        print("Starting player name: \(winningPlayer.name.description)")
//
//        return winningPlayer.id
//    }
//
//    func getPlayerIdForFirstPlayerThisPhase() -> Int {
//        return playerIdForFirstPlayerThisPhase
//    }
//
//    // New
//    func getLargestPlayerId() -> Int {
//        guard let playersById = activeGame?.players.sorted(by: { $0.id < $1.id }),
//              let lastPlayersId = playersById.last?.id
//        else {
//            fatalError("No active game")
//        }
//
//        return lastPlayersId
//    }
//
//    func getSuitPlayedFirst() -> CardSuit? {
//        // If the first player didn't play a number card, we need to keep checking other players.
//        let lastPlayersId = getLargestPlayerId()
//
//        // Get the cards played, and the person who played first in the phase
//        let cardsPlayed = deck.getCardsInPlay()
//        var currentIdToCheck = getPlayerIdForFirstPlayerThisPhase()
//
//        // We'll use a mod operator to loop player ids once we reach the end.
//        var hasLoopedPlayerIds = false
//        // Break the while loop when we've hit every player
//        while !hasLoopedPlayerIds {
//            // Get the number cards played by the current player we're checking.
//            let cardsPlayedByCurrentlyCheckedPlayer = cardsPlayed.filter { card in
//                return card.playedByPlayerWithId == currentIdToCheck
//            }.map { card in
//                return card as? NumberCard
//            }
//
//            // If there is one, we need to return it's suit.
//            if let foundCard = cardsPlayedByCurrentlyCheckedPlayer.first,
//               let foundSuit = foundCard?.suit {
//                return foundSuit
//            }
//
//            // If there isn't one, we need to check the next players id
//            currentIdToCheck += 1
//
//            /// playerId = 2 lastPlayerId = 5; 2 % 5 = 2
//            /// playerId = 3 lastPlayerId = 5; 3 % 5 = 3
//            /// playerId = 4 lastPlayerId = 5; 4 % 5 = 4
//            /// playerId = 5 lastPlayerId = 5; 5 % 5 = 0
//            /// playerId = 1 lastPlayerId = 5; 1 % 5 = 1
//            /// playerId = 2 lastPlayerId = 5; 2 % 5 = 2
//            /// playerId = 3 lastPlayerId = 5; 3 % 5 = 3
//            // This should properly update the id we're checking.
//            if currentIdToCheck % lastPlayersId != 0 {
//                currentIdToCheck = currentIdToCheck % lastPlayersId
//            }
//
//            // If we're hitting this id again, then we've looped and need to break out of the loop.
//            if currentIdToCheck == getPlayerIdForFirstPlayerThisPhase() {
//                hasLoopedPlayerIds = true
//            }
//        }
//
//        // No number card has been played yet.
//        return nil
//    }
//    
//    func playerHasSuitInHand(_ player: Player, suit: CardSuit?) -> Bool {
//        let numberCards = player.cards.compactMap { card in
//            return card as? NumberCard
//        }
//        let cardSuits = numberCards.map { $0.suit }
//        if let suit {
//            return cardSuits.contains(suit)
//        }
//        return false
//    }
//
//    func isSuit(for card: NumberCard,
//                suit: CardSuit?) -> Bool {
//        deck.cardIsSuit(for: card, suit: suit)
//    }
//
//    func scoreRound() {
//        guard let players = activeGame?.players else { return }
//
//        for player in players {
//            let bidValue = player.activeBid.value
//            let score = player.currentScore
//
//            if bidValue == score {
//                player = PlayerBuilder(base: player)
//                            .with(scoreTotal: score + 10)
//                            .build()
//            }
//
//            player = PlayerBuilder(base: player)
//                .with(activeBid: Bid.Builder().build())
//                .with(currentScore: 0)
//                .build()
//        }
//    }
//
//    func passCards(passesForward: Bool) {
//        guard let players = activeGame?.players else { fatalError("No players") }
//
//        for card in cardsPlayed {
//            var currentPlayer: Player?
//            var sendToPlayer: Player?
//
//            for player in players where player.id == card.playedByPlayerWithId {
//                currentPlayer = player
//            }
//
//            guard let currentPlayer else { fatalError("No current player") }
//
//            if passesForward {
//                if currentPlayer.id == players.count {
//                    sendToPlayer = players.first
//                } else {
//                    for player in players where player.id == (currentPlayer.id + 1) {
//                        sendToPlayer = player
//                    }
//                }
//            } else {
//                if currentPlayer.id == players.first?.id {
//                    sendToPlayer = players.last
//                } else {
//                    for player in players where player.id == (currentPlayer.id - 1) {
//                        sendToPlayer = player
//                    }
//                }
//            }
//
//            guard let sendToPlayer else { fatalError("No player to send card to") }
//            
//            deck.moveCardFromOneStackIntoAnother(card: card,
//                                                 stack1: &self.deck.deck.cardsInPlay,
//                                                 stack2: &sendToPlayer.cards)
//        }
//    }
//
//    //    func initialize() {
//    //        self.id = UUID().uuidString
//    //        self.players = players
//    //        self.endOfGame = false
//    //
//    //        guard !self.players.isEmpty
//    //        else {
//    //            fatalError("No Players Passed In")
//    //        }
//    //
//    //        let round1 = Round(roundName: "Round One",
//    //                                numberOfCardsToPlay: 7,
//    //                                players: self.players,
//    //                                passesForward: true)
//    //
//    //        rotate(players: &self.players)
//    //        let round2 = Round(roundName: "Round Two",
//    //                                numberOfCardsToPlay: 5,
//    //                                players: self.players,
//    //                                passesForward: true)
//    //
//    //        rotate(players: &self.players)
//    //        let round3 = Round(roundName: "Round Three",
//    //                                numberOfCardsToPlay: 3,
//    //                                players: self.players,
//    //                                passesForward: true)
//    //
//    //        rotate(players: &self.players)
//    //        let round4 = Round(roundName: "Round Four",
//    //                                numberOfCardsToPlay: 1,
//    //                                players: self.players)
//    //
//    //        rotate(players: &self.players)
//    //        let round5 = Round(roundName: "Round Five",
//    //                                numberOfCardsToPlay: 2,
//    //                                players: self.players,
//    //                                passesForward: false)
//    //
//    //        rotate(players: &self.players)
//    //        let round6 = Round(roundName: "Round Six",
//    //                                numberOfCardsToPlay: 4,
//    //                                players: self.players,
//    //                                passesForward: false)
//    //
//    //        rotate(players: &self.players)
//    //        let round7 = Round(roundName: "Round Seven",
//    //                                numberOfCardsToPlay: 6,
//    //                                players: self.players,
//    //                                passesForward: false)
//    //
//    //        self.rounds = [round1, round2, round3, round4, round5, round6, round7]
//    //        self.activeRound = rounds.first!
//    //    }
//
//    // passesForward is an indicator that the round should include a phase for passing a card left or right. If nil, that round shouldn't include a passing phase.
//    //    func initialize() {
//    //        self.roundName = roundName
//    //        self.numberOfCardsToPlay = numberOfCardsToPlay
//    //        self.bidsByPlayer = []
//    //
//    //        // Setup bidding phase
//    //        let biddingPhase = PhaseModel(players: players,
//    //                                      id: 0,
//    //                                      firstPlayerId: players.first?.id)
//    //        self.phases.append(biddingPhase)
//    //
//    //        // Setup card transfer phase
//    //        if let passesForward {
//    //            let cardTransferPhase = PhaseModel(players: players, id: -1,
//    //                                               firstPlayerId: players.first?.id,
//    //                                               passesForward: passesForward)
//    //
//    //            self.phases.append(cardTransferPhase)
//    //        }
//    //
//    //        // Iterate through players and setup phases based on player order.
//    //        for i in 1...numberOfCardsToPlay {
//    //            var newPhase: PhaseModel?
//    //            if i == 1 {
//    //                newPhase = PhaseModel(players: players,
//    //                                      id: i,
//    //                                      firstPlayerId: players.first?.id)
//    //            } else {
//    //                newPhase = PhaseModel(players: players, id: i, firstPlayerId: nil)
//    //            }
//    //
//    //            if let newPhase {
//    //                self.phases.append(newPhase)
//    //            }
//    //        }
//    //
//    //        let firstPhase = phases.compactMap({ phase in
//    //            if phase.firstPlayerId != nil {
//    //                return phase
//    //            }
//    //            return nil
//    //        }).first
//    //
//    //        guard let firstPhase
//    //        else {
//    //            fatalError("Round created without setting up first phase")
//    //        }
//    //
//    //        self.activePhase = firstPhase
//    //    }
//
//    //    func firstPlayerIdSet() -> Phase {
//    //        if let firstPlayerId {
//    //            var turns: [Turn] = []
//    //            while players?.first?.id != firstPlayerId {
//    //                rotate(players: &players)
//    //            }
//    //
//    //            for player in players {
//    //                let turn = Turn.Builder().with(activePlayer: player).build()
//    //                turns.append(turn)
//    //            }
//    //
//    //            self.activeTurn = turns[0]
//    //        }
//    //    }
//    //
//    //    func initialize(id: UUID,
//    //                    players: [Player],
//    //                    firstPlayerId: UUID,
//    //                    cardsPlayed: [Card],
//    //                    passesForward: Bool? = nil) -> Phase {
//    //
//    //        var turns: [Turn] = []
//    //        for player in players {
//    //            let turn = Turn.Builder.with(activePlayer: player).build()
//    //            turns.append(turn)
//    //        }
//    //
//    //        return Phase.Builder
//    //            .update(id: id)
//    //            .with(turns: turns)
//    //            .with(activeTurn: turns[0])
//    //            .with(cardsPlayed: cardsPlayed)
//    //            .with(players: players)
//    //            .with(firstPlayerId: firstPlayerId)
//    //            .passesForward(passesForward)
//    //            .build()
//    //    }
//
//
//    func isPassingPhase() -> Bool {
//        return activeGame?.activeRound.activePhase.passesForward != nil
//    }
//
//    func passesForward() -> Bool {
//        if isPassingPhase() {
//            guard let activeGame,
//                  let passesForward = activeGame.activeRound.activePhase.passesForward
//            else { fatalError("No active game") }
//            return passesForward
//        }
//        return false
//    }
//
//    func getEndTurnType() -> EndTurnType {
//        return self.endTurnType
//    }
//
//    func resetPlayerCardStates(player: Player) {
//        // Reset the card states
//        for card in player.cards {
//            card.tappedState = .notTapped
//            card.selectedState = .notSelected
//        }
//    }
//
//    func dealCards(to players: inout [Player],
//                   on round: inout Round) {
//        for _ in 0..<round.numberOfCardsToPlay {
//            for player in players {
//                if let topCard: CardProtocol = self.deck.cards.first {
//                    moveCardFromOneStackIntoAnother(card: topCard,
//                                                    stack1: &self.deck.cards,
//                                                    stack2: &player.cards)
//                }
//            }
//        }
//
//        for player in players {
//            organizeHand(for: player)
//        }
//    }
//
//    /// Organizes a players hand by order of suit, value and then special card type.
//    func organizeHand(for player: Player) async throws -> Player {
//        let numberCards = player.cards?.compactMap { $0.unwrapNumberCard() } ?? []
//        let specialCards = player.cards?.compactMap { $0.unwrapSpecialCard() } ?? []
//
//        let sortedNumberCards = try numberCards
//                                    .sort(by: .cardSuit)
//                                    .sort(by: .cardValue)
//                                    .map { $0.wrap() }
//        let sortedSpecialCards = try specialCards.sort().map { $0.wrap() }
//
//        let sortedCards = sortedNumberCards + sortedSpecialCards
//        return try Player.Builder.with(base: player).with(cards: sortedCards).build()
//    }
//
//    func newRound(in game: inout GameModel) {
//        // Move all cards in discard pile back to main deck
//        for card in self.deck.discardPile {
//            moveCardFromOneStackIntoAnother(card: card,
//                                            stack1: &self.deck.discardPile,
//                                            stack2: &self.deck.cards)
//        }
//
//        // Move all cards in all players hands back to deck
//        for player in game.players {
//            for card in player.cards {
//                moveCardFromOneStackIntoAnother(card: card,
//                                                stack1: &player.cards,
//                                                stack2: &self.deck.cards)
//            }
//        }
//
//        for card in deck.cardsInPlay {
//            moveCardFromOneStackIntoAnother(card: card,
//                                            stack1: &self.deck.cardsInPlay,
//                                            stack2: &self.deck.cards)
//        }
//
//        // Shuffle the deck
//        self.deck.cards.shuffle()
//
//        // Deal the cards to all the players
//        dealCards(to: &game.players, on: &game.activeRound)
//
//        // Get the trump card for the round
//        game.activeRound.trump = getNewTrump()
//        print("==")
//        print("Trump: \(game.activeRound.trump)")
//    }
//
//    func moveCardFromTopIntoDeck() {
//        // Pull the top card, put it into the back of the deck and shuffle
//        let topCard: CardProtocol = self.deck.cards.remove(at: 0)
//        self.deck.cards.append(topCard)
//        self.deck.cards.shuffle()
//
//        // Check the top card again, if they match, repeat.
//        let topCardSecondPass: CardProtocol = self.deck.cards.remove(at: 0)
//        if topCard == topCardSecondPass {
//            moveCardFromTopIntoDeck()
//        }
//    }
//
//    func newTurn(card: CardProtocol, stack: inout [CardProtocol]) {
//        moveCardFromOneStackIntoAnother(card: card,
//                                        stack1: &stack,
//                                        stack2: &self.deck.cardsInPlay)
//    }
//
//    func newPhase() {
//        for card in self.deck.cardsInPlay {
//            moveCardFromOneStackIntoAnother(card: card,
//                                            stack1: &self.deck.cardsInPlay,
//                                            stack2: &self.deck.discardPile)
//        }
//    }
//
//    func moveCardFromOneStackIntoAnother(card: Card,
//                                         stack1: inout [Card],
//                                         stack2: inout [Card]) {
//        // Get the index of the card to be removed
//        let index = stack1.firstIndex { cardToRemove in
//            
//            // Check if the card is a numberCard
//            if let numCard = card as? NumberCard,
//               let numToRemove = cardToRemove as? NumberCard {
//                return numCard.value == numToRemove.value && numCard.suit == numToRemove.suit
//            }
//            
//            // Check if the card is a specialCard
//            if let specCard = card as? SpecialCard,
//               let specToRemove = cardToRemove as? SpecialCard {
//                return specCard.type == specToRemove.type
//            }
//            
//            // Return false if neither, this will happen if the card isn't in the stack passed in.
//            return false
//        }
//        
//        // If the index exists, remove it from the stack and add it to the discard pile
//        if let index {
//            stack1.remove(at: index)
//            stack2.append(card)
//        }
//    }
//
//    /// Checks if a card is of a specific suit.
//    func cardIsSuit(for card: NumberCard, suit: CardSuit?) async -> Bool {
//        if let suit { return card.suit == suit }
//        return false
//    }
//
//    // Returns a list of cards which are currently in the play area.
//    func getCardsInPlay() async -> [Card] {
//        guard let cardsInPlay = activeGame?.activeRound?.activeTrick?.cardsPlayed
//        else { return [] }
//        return cardsInPlay
//    }
//
//    func getActiveTrump() async throws -> CardSuit {
//        guard let trump = activeGame?.activeRound?.trump
//        else {
//            try await deck.getNewTrump()
//            return try await getActiveTrump()
//        }
//
//        return trump
//    }
}
