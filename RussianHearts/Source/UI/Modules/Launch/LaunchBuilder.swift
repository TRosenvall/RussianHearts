//
//  LaunchBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import Foundation

class LaunchBuilder {

    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(
        delegate: SceneCoordinating,
        assets: Assets,
        colors: Colors,
        entityAccessor: (any EntityAccessing)
    ) throws -> any LaunchHost {
        Logger.default.log("Building Launch Host")

        // Theme
        let theme = LaunchTheme(assets: assets, colors: colors)

        // Use Cases
        let loadSavedData = try LoadSavedData.Builder
            .with(entityAccessor: entityAccessor)
            .build()

        let useCases = try Launch.UseCases.Builder
            .with(loadSavedData: loadSavedData)
            .build()

        // App State
        let alerts = try Launch.State.Alerts.Builder.build()
        let state = try Launch.State.Builder
            .with(alerts: alerts)
            .build()
        let entity = try LaunchEntity.Builder
            .with(states: [state])
            .with(completionState: .active)
            .build()
        try Global.updateEntity(entity, using: entityAccessor) { result in
            switch result {
            case .success:
                Logger.default.log("Launch Entity Saved On Initialization")
            case .error(let error):
                Logger.default.logFatal("Error Saving Launch Entity: - \(error)")
            }
        }

        // Routing
        Logger.default.log("Setting Up Routing")
        let routes: ((Launch.UIRoute) -> ()) = { route in
            do {
                // Try To Remove Unneeded Entity
                try Global.deleteEntity(entity, using: entityAccessor) { result in
                    switch result {
                    case .success:
                        Logger.default.log("Launch Entity Removed On Route")
                    case .error(let error):
                        Logger.default.logFatal("Error Saving Launch Entity: - \(error)")
                    }

                    // Route on Main Thread
                    Task { @MainActor in
                        switch route {
                        case .toMainMenu:
                            Logger.default.log("Routing To Main Menu")
                            delegate.routeToMainMenu()
                        }
                    }
                }
            } catch {
                Logger.default.log("Error Deleting Entity On Route")
            }
        }

        // Transformer
        let transformer = LaunchTransformer()

        // View
        let view: LaunchViewImpl = LaunchViewImpl.init(
            theme: theme,
            state: state
        )

        // View Model
        let viewModel = try LaunchViewModelImpl.Builder
            .with(useCases: useCases)
            .with(uiRoutes: routes)
            .with(transformer: transformer)
            .with(view: view)
            .build()

        let module: any LaunchHost = LaunchHostingController(viewModel: viewModel)

        return module
    }
}
