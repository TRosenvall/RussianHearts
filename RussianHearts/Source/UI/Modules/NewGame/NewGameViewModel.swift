//
//  NewGameViewModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import SwiftUI

protocol NewGameViewModel: ModuleViewModel {
    var view: NewGameViewImpl? { get }
}

struct NewGameViewModelImpl:
    NewGameViewModel,
    LoadSavedDataOutput
{

    // MARK: - Properties

    typealias UIEvent = NewGame.UIEvent
    typealias ModuleError = NewGame.ModuleError
    typealias UIRoute = NewGame.UIRoute
    typealias ModuleState = NewGame.State
    typealias AssociatedEntity = NewGameEntity

    let id: UUID
    var view: NewGameViewImpl? = nil

    let uiRoutes: ((NewGame.UIRoute) -> ())?
    let useCases: NewGame.UseCases?
    let transformer: NewGameTransformer?

    // MARK: - Lifecycle

    internal init(with base: NewGameViewModelImpl?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: NewGameViewModelImpl? = nil,
        id: UUID? = nil,
        uiRoutes: ((NewGame.UIRoute) -> ())? = nil,
        useCases: NewGame.UseCases? = nil,
        transformer: NewGameTransformer? = nil,
        view: NewGameViewImpl? = nil
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

    // MARK: - Conformance: NewGameViewModel

    func handleUIEvent(_ event: NewGame.UIEvent) {
        Logger.default.log("Handling \(event) Event")

        Task { @MainActor in
            switch event {
            case .didAppear:
                print("")
            case .didTapNewGame:
                uiRoutes?(.toNewGame)
            case .didTapContinueGame(let entity):
                uiRoutes?(.toContinueGame(entity: entity))
            case .didTapRules:
                uiRoutes?(.toRules)
            case .didTapHighscores:
                uiRoutes?(.toHighscores)
            case .didTapFriends:
                uiRoutes?(.toFriends)
            case .didTapSettings:
                uiRoutes?(.toSettings)
            }
        }
    }

    func handleError(_ error: NewGame.ModuleError) {
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
//            if let result = result as? LoadSavedDataUseCaseResult {
//                handleLoadSavedDataUseCaseResult(result)
//            } else {
//                // Handle other UseCaseTypes
//            }
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
        let useCases = try values.decode(NewGame.UseCases.self, forKey: .useCases)
        let transformer = try values.decode(NewGameTransformer.self, forKey: .transformer)
        let uiRoutes: ((NewGame.UIRoute) -> ())? = nil
        self = try NewGameViewModelImpl.Builder
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

    private func handleGetActiveEntity(_ result: Global.GetActiveEntityUseCaseResult<NewGameEntity>) {
        Logger.default.log("Handling Get Active Entity Use Case Result")

        Task { @MainActor in
            do {
                switch result {
                case .success(let newGameEntity):
                    if let oldStates = newGameEntity.states {
                        let newState = try NewGame.State.Builder
                            .with(base: newGameEntity.states?.last)
                            .with(isLoading: false)
                            .build()

                        let entity = try NewGameEntity.Builder
                            .with(base: newGameEntity)
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
                guard let entity = updatedEntity as? NewGameEntity,
                      let newState = entity.states?.last
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

extension GenericBuilder where T == NewGameViewModelImpl {
    func with(transformer: NewGameTransformer) -> GenericBuilder<NewGameViewModelImpl> {
        let newBase = NewGameViewModelImpl(base: base, transformer: transformer)
        return GenericBuilder<NewGameViewModelImpl>(base: newBase)
    }

    func with(useCases: NewGame.UseCases) -> GenericBuilder<NewGameViewModelImpl> {
        let newBase = NewGameViewModelImpl(base: base, useCases: useCases)
        return GenericBuilder<NewGameViewModelImpl>(base: newBase)
    }

    func with(uiRoutes: ((NewGame.UIRoute) -> ())?) -> GenericBuilder<NewGameViewModelImpl> {
        let newBase = NewGameViewModelImpl(base: base, uiRoutes: uiRoutes)
        return GenericBuilder<NewGameViewModelImpl>(base: newBase)
    }

    func with(view: NewGameViewImpl) -> GenericBuilder<NewGameViewModelImpl> {
        let newBase = NewGameViewModelImpl(base: base, view: view)
        return GenericBuilder<NewGameViewModelImpl>(base: newBase)
    }
}
