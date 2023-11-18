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
    var interactor: LaunchInput?

    var delegate: LaunchDelegate

    // MARK: - Lifecycle
    init(delegate: LaunchDelegate) {
        self.delegate = delegate
    }

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
        delegate.routeToMainApplication()
    }
}
