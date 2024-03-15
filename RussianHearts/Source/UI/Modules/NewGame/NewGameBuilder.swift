//
//  NewGameBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import Foundation

class NewGameBuilder {

    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(
        delegate: SceneCoordinating,
        assets: Assets,
        colors: Colors,
        entityAccessor: (any EntityAccessing)
    ) throws -> any NewGameHost {
        Logger.default.log("Building NewGame Host")

        // Theme
        let theme = NewGameTheme(assets: assets, colors: colors)

        // Use Cases
        let useCases = try NewGame.UseCases.Builder
            .build()

        // App State
        let alerts = try NewGame.State.Alerts.Builder.build()
        let state = try NewGame.State.Builder
            .with(alerts: alerts)
            .build()
        let entity = try NewGameEntity.Builder
            .with(states: [state])
            .with(completionState: .active)
            .build()
        try Global.updateEntity(entity, using: entityAccessor) { result in
            switch result {
            case .success:
                Logger.default.log("Main Menu Entity Saved On Initialization")
            case .error(let error):
                Logger.default.logFatal("Error Saving Main Menu Entity: - \(error)")
            }
        }

        // Routing
        Logger.default.log("Setting Up Routing")
        let routes: ((NewGame.UIRoute) -> ()) = { route in
            do {
                // Try To Remove Unneeded Entity
                try Global.deleteEntity(entity, using: entityAccessor) { result in
                    switch result {
                    case .success:
                        Logger.default.log("Main Menu Entity Removed On Route")
                    case .error(let error):
                        Logger.default.logFatal("Error Saving Main Menu Entity: - \(error)")
                    }

                    // Route on Main Thread
                    Task { @MainActor in
                        switch route {
                        case .toNewGame:
                            Logger.default.log("Routing To New Game")
                            delegate.routeToNewGame()
                        case .toContinueGame(let entity):
                            Logger.default.log("Routing To Continue Game")
                            delegate.routeToGame(with: entity)
                        case .toRules:
                            Logger.default.log("Routing To Rules")
                            delegate.routeToRules()
                        case .toHighscores:
                            Logger.default.log("Routing To Highscores")
                            delegate.routeToHighScores()
                        case .toFriends:
                            Logger.default.log("Routing To Friends")
                            delegate.routeToFriends()
                        case .toSettings:
                            Logger.default.log("Routing To Settings")
                            delegate.routeToSettings()
                        }
                    }
                }
            } catch {
                Logger.default.log("Error Deleting Entity On Route")
            }
        }

        // Transformer
        let transformer = NewGameTransformer()

        // View
        let view: NewGameViewImpl = NewGameViewImpl.init(
            theme: theme,
            state: state
        )

        // View Model
        let viewModel = try NewGameViewModelImpl.Builder
            .with(useCases: useCases)
            .with(uiRoutes: routes)
            .with(transformer: transformer)
            .with(view: view)
            .build()

        let module: any NewGameHost = NewGameHostingController(viewModel: viewModel)

        return module
    }
}
