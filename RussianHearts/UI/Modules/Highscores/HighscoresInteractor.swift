//
//  HighscoresInteractor.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/19/23.
//

import Foundation

class HighscoresInteractor: HighscoresInput {

    // MARK: - Properties
    var output: HighscoresOutput?
    var serviceManager: ServiceManaging

    // MARK: - Lifecycle
    init(serviceManager: ServiceManaging = ServiceManager.shared) {
        self.serviceManager = serviceManager
    }

    // MARK: - Conformance: HighscoresInput

    // MARK: - Helpers
}
