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
        var presenter: HighscoresPresenting = HighscoresPresenter()
        var interactor: HighscoresInput = HighscoresInteractor()
        let router: HighscoresWireframe = HighscoresRouter(delegate: delegate)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter as? HighscoresOutput

        return view
    }
}
