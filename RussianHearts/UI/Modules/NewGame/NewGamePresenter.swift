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
    var interactor: NewGameInput?

    var delegate: NewGameDelegate

    // MARK: - Lifecycle
    init(delegate: NewGameDelegate) {
        self.delegate = delegate
    }

    // MARK: - Conformance: NewGamePresenting
    func backButtonTapped() {
        delegate.routeBack(animated: true)
    }

    func startNewGame(with playerValues: [Int? : String?]) {
        interactor?.startNewGame(with: playerValues)
    }

    // MARK: - Conformance: NewGameOutput
    func routeToGameModule() {
        delegate.routeToGameModule()
    }

    // MARK: - Helpers
}
