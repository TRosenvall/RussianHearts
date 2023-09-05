//
//  NewGamePresenter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

class NewGamePresenter: NewGamePresenting, NewGameOutput {

    // MARK: - Properties
    var view: (any NewGameView)?
    var router: NewGameWireframe?
    var interactor: NewGameInput?

    // MARK: - Lifecycle

    // MARK: - Conformance: NewGamePresenting
    func backButtonTapped() {
        router?.backButtonTapped()
    }

    func startNewGame(with playerValues: [Int? : String?]) {
        interactor?.startNewGame(with: playerValues)
    }

    // MARK: - Conformance: NewGameOutput
    func routeToGameModule() {
        router?.routeToGameModule()
    }

    // MARK: - Helpers
}
