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
        let getActiveLaunchState = try GetActiveLaunchState.Builder
            .with(entityAccessor: entityAccessor)
            .build()

        let useCases = try Launch.UseCases.Builder
            .with(loadSavedData: loadSavedData)
            .with(getActiveLaunchState: getActiveLaunchState)
            .build()

        // Routing
        Logger.default.log("Setting Up Routing")
        let routes: ((Launch.UIRoute) -> ()) = { route in
            switch route {
            case .toMainMenu:
                Logger.default.log("Routing To Main Menu")
                delegate.routeToMainMenu()
            }
        }

        // Transformer
        let transformer = LaunchTransformer()

        // View Model
        let viewModel = try LaunchViewModelImpl.Builder
            .with(useCases: useCases)
            .with(uiRoutes: routes)
            .with(transformer: transformer)
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
        try UpdateEntityUseCase.update(withNewEntity: entity, using: entityAccessor) { result in
            switch result {
            case .success(let entity):
                Logger.default.log("Launch Entity Saved On Initialization")
            case .error(let error):
                Logger.default.logFatal("Error Saving Launch Entity: - \(error)")
            }
        }

        // View and Host
        let view: LaunchViewImpl = LaunchViewImpl.init(viewModel: viewModel,
                                                       theme: theme,
                                                       state: state)
        let module: any LaunchHost = LaunchHostingController(view: view)

        return module
    }
}
