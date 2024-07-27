//
//  GameHostingController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import SwiftUI

// Determines how to call on required dependencies for routing
protocol GameHost: ModuleController {}

class GameHostingController: UIHostingController<GameViewImpl<GameViewModelImpl>>, GameHost {

    // MARK: - Properties

    var module: Module = .Game
    var shouldRelease: Bool = false

    // MARK: - Lifecycle

    override init(rootView: GameViewImpl<GameViewModelImpl>) {
        Logger.default.log("Initializing New Game Host")

        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        Logger.default.logFatal("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

