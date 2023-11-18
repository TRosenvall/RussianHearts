//
//  HighscoresBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/19/23.
//

import Foundation

class HighscoresBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any HighscoresView {
        let view: any HighscoresView = HighscoresViewController()
        var presenter: HighscoresPresenting = HighscoresPresenter(delegate: delegate)
        var interactor: HighscoresInput = HighscoresInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter as? HighscoresOutput

        return view
    }
}
