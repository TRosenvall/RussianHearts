//
//  GameViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/9/23.
//

import UIKit

// Determines how to call on required dependencies for routing
protocol GameDelegate: ModuleDelegate {
    func routeToMainMenu()

    func routeToHighScores()
}

protocol GameView: ModuleController {
    var worker: GameWorker? { get set }
    var delegate: GameDelegate? { get set }
}

class GameViewController:
    UIViewController,
    GameView,
    GameMainViewDelegate
{

    // MARK: - Properties
    var module: Module = Module.Game
    var worker: GameWorker?

    weak var delegate: GameDelegate?

    // MARK: - Views
    lazy var mainView: GameMainView = {
        let view = GameMainView(moduleColor: module.color)
        view.delegate = self

        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)

        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        return view
    }()

    // MARK: - Lifecycle
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
    func getPlayer() -> PlayerModel {
        guard let worker
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return worker.getActivePlayer()
    }

    func getPlayers() -> [PlayerModel] {
        guard let worker
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return worker.getAllPlayers()
    }

    func endTurn(cardPlayed: Card?) -> EndTurnType {
        guard let worker
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return worker.endTurn(cardPlayed: cardPlayed)
    }

    func routeToMainMenu() {
        delegate?.routeToMainMenu()
    }

    func routeToHighScores() {
        delegate?.routeToHighScores()
    }

    func getPlayedCards() -> [Card] {
        return worker?.getPlayedCards() ?? []
    }

    func getPlayerIdForFirstPlayerThisPhase() -> Int? {
        return worker?.getPlayerIdForFirstPlayerThisPhase()
    }

    func getTrump() -> CardSuit? {
        return worker?.getTrump()
    }

    // MARK: - Helpers
}
