//
//  LaunchViewModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import SwiftUI

protocol LaunchViewModel: ModuleViewModel {}

struct LaunchViewModelImpl:
    LaunchViewModel,
    LoadSavedDataOutput
{

    // MARK: - Properties

    typealias UIEvent = Launch.UIEvent
    typealias ModuleError = Launch.ModuleError
    typealias UIRoute = Launch.UIRoute
    typealias ModuleState = Launch.State
    typealias AssociatedEntity = LaunchEntity

    let id: UUID
    var view: LaunchViewImpl? = nil

    let uiRoutes: ((Launch.UIRoute, (any ModuleController)?) -> ())?
    let useCases: Launch.UseCases?
    let transformer: LaunchTransformer?

    // MARK: - Lifecycle

    internal init(with base: LaunchViewModelImpl?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: LaunchViewModelImpl? = nil,
        id: UUID? = nil,
        uiRoutes: ((Launch.UIRoute, (any ModuleController)?) -> ())? = nil,
        useCases: Launch.UseCases? = nil,
        transformer: LaunchTransformer? = nil,
        view: LaunchViewImpl? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.uiRoutes = uiRoutes ?? base?.uiRoutes
        self.useCases = useCases ?? base?.useCases
        self.transformer = transformer ?? base?.transformer

        if var view {
            view.eventHandler = self.handleUIEvent(_:)
            self.view = view
        } else {
            self.view = base?.view
        }

        if self.view == nil {
            Logger.default.log("View Model Created Without View", logType: .warn)
        }
    }

    // MARK: - Conformance: Model

    func validate() throws -> Self {
        guard useCases != nil, transformer != nil, view != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        /// This code is here to ensure uiRoutes have been set on the view model. If they haven't
        /// and because they aren't codable, we reset the app. This should never be called but it's
        /// here just in case. It's written using a label and defer functions to exit the function
        /// without throwing or returning.
        resetScope: do {
            guard uiRoutes != nil 
            else {
                defer { Global.sceneDelegate?.reset() }
                break resetScope
            }
        }

        return self
    }

    // MARK: - Conformance: LaunchViewModel

    func handleUIEvent(_ event: Launch.UIEvent) {
        Logger.default.log("Handling \(event) Event")

        Task { @MainActor in
            switch event {
            case .didAppear:
                let loadSavedData = useCases?.loadSavedData?.value() as? (any LoadSavedDataUseCase)
                UseCaseManager.sharedInstance.execute(
                    loadSavedData,
                    completion: handleUseCaseResult(_:)
                )
            }
        }
    }

    func handleError(_ error: Launch.ModuleError) {
        Logger.default.log("Handing \(error) Error")

        Task { @MainActor in
            switch error {
            case .failed:
                print("Failed")
            case .noSavedGamesFound:
                print("No Saved Data")
            }
        }
    }

    // MARK: - Conformance: UseCaseOutput

    func handleUseCaseResult(_ result: UseCaseResultType) {
        Logger.default.log("Sorting Use Case Result Type")

        Task { @MainActor in
            if let result = result as? LoadSavedDataUseCaseResult {
                handleLoadSavedDataUseCaseResult(result)
            } else {
                // Handle other UseCaseTypes
            }
        }
    }

    // MARK: - Conformance: Codable

    enum CodingKeys: String, CodingKey {
        case id
        case useCases
        case transformer
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decode(ID.self, forKey: .id)
        let useCases = try values.decode(Launch.UseCases.self, forKey: .useCases)
        let transformer = try values.decode(LaunchTransformer.self, forKey: .transformer)
        let uiRoutes: ((Launch.UIRoute, (any ModuleController)?) -> ())? = nil
        self = try LaunchViewModelImpl.Builder
            .update(id: id)
            .with(useCases: useCases)
            .with(uiRoutes: uiRoutes)
            .with(transformer: transformer)
            .build()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(useCases, forKey: .useCases)
        try container.encode(transformer, forKey: .transformer)
    }

    // MARK: - Helpers

    private func handleLoadSavedDataUseCaseResult(_ result: LoadSavedDataUseCaseResult) {
        Logger.default.log("Handling Load Saved Data Use Case Result")

        Task { @MainActor in
            do {
                try Global.getActive(completion: handleGetActiveEntity)

            } catch {
                Logger.default.log("Unable To Update State", logType: .warn)
            }

            switch result {
            case .success(let gameEntity):
                uiRoutes?(.toMainMenu(entity: gameEntity), nil)
            case .error(let error):
                switch error {
                case .noGameStateRetrieved:
                    Logger.default.log("Routing With No Saved Data", logType: .warn)
                    uiRoutes?(.toMainMenu(entity: nil), nil)
                }
            }
        }
    }

    private func handleGetActiveEntity(_ result: Global.GetActiveEntityUseCaseResult<LaunchEntity>) {
        Logger.default.log("Handling Get Active Entity Use Case Result")

        Task { @MainActor in
            do {
                switch result {
                case .success(let launchEntity):
                    if let oldStates = launchEntity.gameStates {
                        let newState = try Launch.State.Builder
                            .with(base: launchEntity.gameStates?.last)
                            .with(isLoading: false)
                            .build()

                        let entity = try LaunchEntity.Builder
                            .with(base: launchEntity)
                            .with(states: oldStates + [newState])
                            .build()

                        try Global.updateEntity(entity, completion: handleUpdateEntity)
                    }
                case .error(let error): Logger.default.log(error.localizedDescription, logType: .warn)
                }
            } catch {
                Logger.default.log("Unable To Build New Entity", logType: .warn)
            }
        }
    }

    private func handleUpdateEntity(_ result: Global.UpdateEntityUseCaseResult) {
        Logger.default.log("Handling Update Entity Use Case Result")

        Task { @MainActor in
            switch result {
            case .success(let updatedEntity):
                guard let entity = updatedEntity as? LaunchEntity,
                      let newState = entity.gameStates?.last
                else {
                    Logger.default.log("Entity Did Not Update", logType: .warn)
                    return
                }
                
                self.view?.state = newState
            case .error(let error): Logger.default.log(error.localizedDescription, logType: .warn)
            }
        }
    }
}

extension GenericBuilder where T == LaunchViewModelImpl {
    func with(transformer: LaunchTransformer) -> GenericBuilder<LaunchViewModelImpl> {
        let newBase = LaunchViewModelImpl(base: base, transformer: transformer)
        return GenericBuilder<LaunchViewModelImpl>(base: newBase)
    }

    func with(useCases: Launch.UseCases) -> GenericBuilder<LaunchViewModelImpl> {
        let newBase = LaunchViewModelImpl(base: base, useCases: useCases)
        return GenericBuilder<LaunchViewModelImpl>(base: newBase)
    }

    func with(uiRoutes: ((Launch.UIRoute, (any ModuleController)?) -> ())?) -> GenericBuilder<LaunchViewModelImpl> {
        let newBase = LaunchViewModelImpl(base: base, uiRoutes: uiRoutes)
        return GenericBuilder<LaunchViewModelImpl>(base: newBase)
    }

    func with(view: LaunchViewImpl) -> GenericBuilder<LaunchViewModelImpl> {
        let newBase = LaunchViewModelImpl(base: base, view: view)
        return GenericBuilder<LaunchViewModelImpl>(base: newBase)
    }
}
