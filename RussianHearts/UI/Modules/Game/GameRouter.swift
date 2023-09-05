//
//  GameRouter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/1/23.
//

import Foundation

class GameRouter: GameWireframe {

    // MARK: - Properties
    var delegate: GameDelegate

    // MARK: - Lifecycle
    init(delegate: GameDelegate) {
        self.delegate = delegate
    }

    // MARK: - Conformance: GameWireframe
}
