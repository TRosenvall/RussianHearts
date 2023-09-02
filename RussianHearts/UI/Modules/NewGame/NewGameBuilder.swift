//
//  NewGameBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

class NewGameBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any NewGameView {
        let view: any NewGameView = NewGameViewController()
        var presenter: NewGamePresenting = NewGamePresenter()
        var interactor: NewGameInput = NewGameInteractor()
        let router: NewGameWireframe = NewGameRouter(delegate: delegate)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter as? NewGameOutput

        return view
    }
}
