//
//  MainMenuHostingController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import UIKit
import SwiftUI

// Determines how to call on required dependencies for routing
protocol MainMenuHost: ModuleController {
    func with(_ entity: GameEntity?) throws -> Self
}

class MainMenuHostingController: UIHostingController<MainMenuViewImpl>, MainMenuHost {

    // MARK: - Properties

    var module: Module = .MainMenu
    var shouldRelease: Bool = false
    var viewModel: any MainMenuViewModel

    // MARK: - Lifecycle

    init(viewModel: any MainMenuViewModel) {
        Logger.default.log("Initializing Main Menu Host")

        self.viewModel = viewModel

        guard let view = viewModel.view
        else { Logger.default.logFatal("Main Menu View Model Missing View") }

        super.init(rootView: view)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        Logger.default.logFatal("init(coder:) has not been implemented")
    }
}

extension MainMenuHostingController {
    func with(_ entity: GameEntity?) throws -> Self {
        if let viewModel = viewModel as? MainMenuViewModelImpl,
           let entity
        {
            let viewModel = try MainMenuViewModelImpl.Builder
                .with(base: viewModel)
                .build()
            viewModel.view?.state = try MainMenu.State.Builder
                .with(base: viewModel.view?.state)
                .with(gameEntity: entity)
                .build()
            return MainMenuHostingController(viewModel: viewModel) as! Self
        }
        return self
    }
}

