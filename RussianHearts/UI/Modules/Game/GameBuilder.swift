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
        var presenter: GamePresenting = GamePresenter()
        var interactor: GameInput = GameInteractor()
        let router: GameWireframe = GameRouter(delegate: delegate)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter as? GameOutput

        return view
    }
}
