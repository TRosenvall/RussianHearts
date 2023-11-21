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
    func build(delegate: SceneCoordinating) -> any GameView {
        let view: any GameView = GameViewController()
        let worker: GameWorker = GameWorkerImpl()

        view.worker = worker
        view.delegate = delegate

        return view
    }
}
