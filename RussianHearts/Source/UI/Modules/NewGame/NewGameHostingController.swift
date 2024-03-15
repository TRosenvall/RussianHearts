//
//  NewGameHostingController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import SwiftUI

// Determines how to call on required dependencies for routing
protocol NewGameHost: ModuleController {}

class NewGameHostingController: UIHostingController<NewGameViewImpl>, NewGameHost {

    // MARK: - Properties

    var module: Module = .NewGame
    var shouldRelease: Bool = false
    var viewModel: any NewGameViewModel

    // MARK: - Lifecycle

    init(viewModel: any NewGameViewModel) {
        Logger.default.log("Initializing New Game Host")

        self.viewModel = viewModel

        guard let view = viewModel.view
        else { Logger.default.logFatal("New Game View Model Missing View") }

        super.init(rootView: view)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        Logger.default.logFatal("init(coder:) has not been implemented")
    }
}

