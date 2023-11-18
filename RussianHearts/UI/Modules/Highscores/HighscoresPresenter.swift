//
//  HighscoresPresenter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/19/23.
//

import Foundation

class HighscoresPresenter: HighscoresPresenting, HighscoresOutput {

    // MARK: - Properties
    var view: (any HighscoresView)?
    var interactor: HighscoresInput?

    var delegate: HighscoresDelegate

    // MARK: - Lifecycle
    init(delegate: HighscoresDelegate) {
        self.delegate = delegate
    }

    // MARK: - Conformance: HighscoresPresenting
    func backButtonTapped() {
        delegate.routeToMainMenu()
    }

    // MARK: - Helpers
}
