//
//  GameBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/1/23.
//

import Foundation

class GameBuilder {

    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating,
               serviceManager: ServiceManaging = ServiceManager.shared) -> any GameView {

        guard let gameService: GameService = serviceManager.retrieveService()
        else {
            fatalError("Game Service Not found")
        }

        let view: any GameView = GameViewController()
        let worker: GameWorker = GameWorkerImpl()

        view.gameService = gameService
        view.delegate = delegate

        return view
    }
}
