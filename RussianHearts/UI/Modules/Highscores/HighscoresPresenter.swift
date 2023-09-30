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
    var router: HighscoresWireframe?
    var interactor: HighscoresInput?

    // MARK: - Lifecycle

    // MARK: - Conformance: HighscoresPresenting
    func backButtonTapped() {
        router?.routeToMainMenu()
    }

    // MARK: - Helpers
}
