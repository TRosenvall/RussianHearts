//
//  GameBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import Foundation

class GameBuilder {

    // MARK: - Helper Functions

    func build(
        delegate: SceneCoordinating,
        assets: Assets,
        colors: Colors,
        entityAccessor: (any EntityAccessing),
        gameEntity: GameEntity
    ) throws -> any GameHost {
        Logger.default.log("Building Game Host")

        // Theme
        let theme = GameTheme(assets: assets, colors: colors)

        // Use Cases
        let useCases = try Game.UseCases.Builder
            .build()

        // App State
        let alerts = try Game.State.Alerts.Builder.build()
        let state = try Game.State.Builder
            .with(alerts: alerts)
            .build()

        let entity = try gameEntity.toBuilder().with(uiStates: [state]).build()

        try Global.updateEntity(entity, using: entityAccessor) { result in
            switch result {
            case .success:
                Logger.default.log("Game Entity Saved On Initialization")
            case .error(let error):
                Logger.default.logFatal("Error Saving Game Entity: - \(error)")
            }
        }

        // Routing
        Logger.default.log("Setting Up Routing")
        let routes: ((Game.UIRoute, (any ModuleController)?) -> ()) = { route, moduleController in
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
                        case .toMainMenu(let entity):
                            Logger.default.log("Routing To Main Menu")
                            delegate.routeBackToMainMenu(from: moduleController)
                        case .toHighScores(let entity):
                            Logger.default.log("Routing To Highscores")
                        }
                    }
                }
            } catch {
                Logger.default.log("Error Deleting Entity On Route")
            }
        }

        // Transformer
        let transformer = GameTransformer()

        // Game Service
        let retrieveGameState = try RetrieveGameState.Builder.with(entityAccessor: entityAccessor).build()

        let useCase = try GameService.UseCase.Builder
            .with(retrieveGameState: retrieveGameState)
            .build()

        let gameService = try GameService.Builder
            .with(useCase: useCase)
            .with(entityAccessor: entityAccessor)
            .build()

        // View Model
        guard let gameState = entity.gameStates?.last
        else { Logger.default.logFatal("Missing Game State") }

        let viewModel = try GameViewModelImpl.Builder
            .with(useCases: useCases)
            .with(uiRoutes: routes)
            .with(transformer: transformer)
            .with(uiState: state)
            .with(gameState: gameState)
            .with(gameService: gameService)
            .build()

        // View
        let view: GameViewImpl = GameViewImpl<GameViewModelImpl>.init(
            theme: theme,
            viewModel: viewModel
        )

        let module: any GameHost = GameHostingController(rootView: view)

        viewModel.hostRef = module

        return module
    }
}
