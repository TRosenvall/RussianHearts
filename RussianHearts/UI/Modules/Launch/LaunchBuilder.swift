//
//  LaunchBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/17/23.
//

import Foundation

class LaunchBuilder {

    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any LaunchView {
        let view: any LaunchView = LaunchViewController()
        var presenter: LaunchPresenting = LaunchPresenter(delegate: delegate)
        var interactor: LaunchInput = LaunchInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter as? LaunchOutput

        return view
    }
}
