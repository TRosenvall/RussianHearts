//
//  NewGamePresenter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

class NewGamePresenter: NewGamePresenting {

    // MARK: - Properties
    var view: (any NewGameView)?
    var router: NewGameWireframe?
    var interactor: NewGameInput?

    // MARK: - Lifecycle

    // MARK: - Conformance: NewGamePresenting
    func backButtonTapped() {
        router?.backButtonTapped()
    }

    // MARK: - Helpers
}
