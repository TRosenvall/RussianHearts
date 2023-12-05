//
//  GameViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/9/23.
//

import UIKit

// Determines how to call on required dependencies for routing
protocol GameDelegate: ModuleDelegate {
    func routeBackToMainMenu(from module: any ModuleController)

    func routeToHighScores()
}

protocol GameView: ModuleController {
    var gameService: GameService? { get set }
    var delegate: GameDelegate? { get set }
}

class GameViewController:
    UIViewController,
    GameView,
    GameMainViewDelegate
{

    // MARK: - Properties
    var module: Module = Module.Game
    var gameService: GameService?

    weak var delegate: GameDelegate?

    // MARK: - Views
    lazy var mainView: GameMainView = {
        let view = GameMainView(delegate: self,
                                moduleColor: module.color)

        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)

        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        return view
    }()

    // MARK: - Lifecycle

    // Other
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.finalUpdates()
    }

    // MARK: - Actions

    // MARK: - Conformance: GameMainViewDelegate
    func getActivePlayer() -> PlayerModel {
        guard let gameService,
              let activeGame = gameService.activeGame
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return activeGame.activeRound.activePhase.activeTurn.activePlayer
    }

    func getPlayers() -> [PlayerModel] {
        guard let gameService,
              let activeGame = gameService.activeGame
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return activeGame.players
    }

    func endTurn(cardPlayed: Card?) -> EndTurnType {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

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
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.deck.getCardsInPlay()
    }

    func getPlayerIdForFirstPlayerThisPhase() -> Int {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.getPlayerIdForFirstPlayerThisPhase()
    }

    func getTrump() -> CardSuit {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.deck.getTrump()
    }

    func getSuitPlayedFirst() -> CardSuit? {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.getSuitPlayedFirst()
    }
    
    func playerHasSuitInHand(_ player: PlayerModel, suit: CardSuit?) -> Bool {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.playerHasSuitInHand(player, suit: suit)
    }

    func isSuit(for card: NumberCard, suit: CardSuit?) -> Bool {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.isSuit(for: card, suit: suit)
    }

    func getNumberOfCardsForRound() -> Int {
        guard let gameService,
              let cardsToPlay = gameService.activeGame?.activeRound.numberOfCardsToPlay
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return cardsToPlay
    }

    func getWinningPlayers() -> [PlayerModel] {
        var winningPlayers: [PlayerModel] = []

        guard let gameService,
              let players = gameService.activeGame?.players
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        var winningPlayer: PlayerModel? = nil
        for player in players {
            if winningPlayer == nil {
                winningPlayer = player
                winningPlayers.append(player)
            } else if let winningPlayerScore = winningPlayer?.scoreTotal,
                      winningPlayerScore == player.scoreTotal {
                winningPlayers.append(player)
            } else if let winningPlayerScore = winningPlayer?.scoreTotal,
                      winningPlayerScore < player.scoreTotal {
                winningPlayer = player
                winningPlayers = []
                winningPlayers.append(player)
            }
        }

        guard winningPlayers.count != 0 else { fatalError("No winner found") }
        return winningPlayers
    }

    func removeGame() {
        gameService?.activeGame = nil
    }

    func isPassingPhase() -> Bool {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.isPassingPhase()
    }

    func passesForward() -> Bool {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.passesForward()
    }

    func getEndTurnType() -> EndTurnType {
        guard let gameService
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }

        return gameService.getEndTurnType()
    }

    func routeToMainMenu() {
        delegate?.routeBackToMainMenu(from: self)
    }

    func routeToHighScores() {
        delegate?.routeToHighScores()
    }

    // MARK: - Helpers
}
