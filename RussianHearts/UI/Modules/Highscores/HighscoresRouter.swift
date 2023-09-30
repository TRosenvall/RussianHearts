//
//  HighscoresRouter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/19/23.
//

import Foundation

class HighscoresRouter: HighscoresWireframe {

    // MARK: - Properties
    var delegate: HighscoresDelegate

    // MARK: - Lifecycle
    init(delegate: HighscoresDelegate) {
        self.delegate = delegate
    }

    // MARK: - Conformance: HighscoresWireframe
    func routeToMainMenu() {
        delegate.routeToMainMenu()
    }

    // MARK: - Helpers
}
