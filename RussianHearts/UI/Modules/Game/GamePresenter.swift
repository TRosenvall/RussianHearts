//
//  GamePresenter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/1/23.
//

import Foundation

class GamePresenter: GamePresenting {

    // MARK: - Properties
    var view: (any GameView)?
    var router: GameWireframe?
    var interactor: GameInput?

    // MARK: - Lifecycle
    init() {}

    // MARK: - Conformance: GamePresenting
    func getPlayer() -> PlayerModel {
        guard let interactor
        else {
            fatalError("Interactor not found, module resolving screwed up")
        }
        return interactor.getActivePlayer()
    }
}
