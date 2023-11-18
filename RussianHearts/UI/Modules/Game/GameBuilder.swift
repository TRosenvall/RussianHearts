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
        var presenter: GamePresenting = GamePresenter(delegate: delegate)
        var interactor: GameInput = GameInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter as? GameOutput

        return view
    }
}
