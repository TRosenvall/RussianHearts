//
//  MainMenuBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

class MainMenuBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any MainMenuView {
        let view: any MainMenuView = MainMenuViewController()
        var presenter: MainMenuPresenting = MainMenuPresenter()
        var interactor: MainMenuInput = MainMenuInteractor()
        let router: MainMenuWireframe = MainMenuRouter(delegate: delegate)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter as? MainMenuOutput

        return view
    }
}
