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
        var presenter: LaunchPresenting = LaunchPresenter()
        var interactor: LaunchInput = LaunchInteractor()
        let router: LaunchWireframe = LaunchRouter(delegate: delegate)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter as? LaunchOutput

        return view
    }
}
