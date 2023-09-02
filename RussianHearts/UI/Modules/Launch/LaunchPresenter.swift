//
//  LaunchPresenter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/17/23.
//

import Foundation

class LaunchPresenter: LaunchPresenting, LaunchOutput {

    // MARK: - Properties
    var view: (any LaunchView)?
    var router: LaunchWireframe?
    var interactor: LaunchInput?

    // MARK: - Lifecycle
    init() {}

    // MARK: - Conformance: LaunchPresenting
    func launchApp() {
        do {
            try interactor?.loadData(from: .local)
        } catch {
            print("///------")
            print("Nonfatal Error")
            print(error)
            routeToMainApplication()
        }
    }
    
    // MARK: - Conformance: LaunchOutput
    func routeToMainApplication() {
        (view as? LaunchViewController)?.activityIndicator.stopAnimating()
        router?.routeToMainApplication()
    }
}
