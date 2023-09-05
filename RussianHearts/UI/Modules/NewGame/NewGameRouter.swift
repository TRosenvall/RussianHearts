//
//  NewGameRouter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

class NewGameRouter: NewGameWireframe {

    // MARK: - Properties
    var delegate: NewGameDelegate

    // MARK: - Lifecycle
    init(delegate: NewGameDelegate) {
        self.delegate = delegate
    }

    // MARK: - Conformance: NewGameWireframe
    func backButtonTapped() {
        delegate.routeBack(animated: true)
    }

    func routeToGameModule() {
        delegate.routeToGameModule()
    }

    // MARK: - Helpers
}
