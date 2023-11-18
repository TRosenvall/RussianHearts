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
        var presenter: NewGamePresenting = NewGamePresenter(delegate: delegate)
        var interactor: NewGameInput = NewGameInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor                  
        interactor.output = presenter as? NewGameOutput

        return view
    }
}
