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
            .with(players: [
                NewGame.Player(isHuman: true, name: ""),
                NewGame.Player(isHuman: true, name: ""),
                NewGame.Player(isHuman: true, name: ""),
                NewGame.Player(isHuman: true, name: ""),
                NewGame.Player(isHuman: true, name: ""),
                NewGame.Player(isHuman: true, name: "")
            ])
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
                        case .toGame(let entity):
                            Logger.default.log("Routing To Game")
                            delegate.routeToGame(with: entity)
                        }
                    }
                }
            } catch {
                Logger.default.log("Error Deleting Entity On Route")
            }
        }

        // Transformer
        let transformer = NewGameTransformer()

        // View Model
        let viewModel = try NewGameViewModelImpl.Builder
            .with(useCases: useCases)
            .with(uiRoutes: routes)
            .with(transformer: transformer)
            .with(state: state)
            .build()

        // View
        let view: NewGameViewImpl = NewGameViewImpl<NewGameViewModelImpl>.init(
            theme: theme,
            viewModel: viewModel
        )

        let module: any NewGameHost = NewGameHostingController(rootView: view)

        return module
    }
}
