//
//  MainMenuRouter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

class MainMenuRouter: MainMenuWireframe {

    // MARK: - Properties
    var delegate: MainMenuDelegate?

    // MARK: - Lifecycle
    init(delegate: MainMenuDelegate) {
        self.delegate = delegate
    }

    // MARK: - Conformance: MainMenuWireframe
    func routeToNewGameModule() {
        delegate?.routeToNewGameModule()
    }
}
