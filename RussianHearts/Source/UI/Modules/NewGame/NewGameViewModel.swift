//
//  NewGameViewModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import SwiftUI

protocol NewGameViewModel: ModuleViewModel, ObservableObject where UIEvent == NewGame.UIEvent {
    
    var state: NewGame.State? { get }
}

class NewGameViewModelImpl:
    NewGameViewModel,
    LoadSavedDataOutput
{

    // MARK: - Types

    typealias ModuleError = NewGame.ModuleError
    typealias UIRoute = NewGame.UIRoute
    typealias ModuleState = NewGame.State
    typealias AssociatedEntity = NewGameEntity

    // MARK: - Properties

    let id: UUID
    @Published var state: NewGame.State?

    let uiRoutes: ((NewGame.UIRoute) -> ())?
    let useCases: NewGame.UseCases?
    let transformer: NewGameTransformer?

    // MARK: - Lifecycle

    required internal convenience init(with base: NewGameViewModelImpl?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: NewGameViewModelImpl? = nil,
        id: UUID? = nil,
        uiRoutes: ((NewGame.UIRoute) -> ())? = nil,
        useCases: NewGame.UseCases? = nil,
        transformer: NewGameTransformer? = nil,
        state: NewGame.State? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.uiRoutes = uiRoutes ?? base?.uiRoutes
        self.useCases = useCases ?? base?.useCases
        self.transformer = transformer ?? base?.transformer
        self.state = state ?? base?.state
    }

    // MARK: - Conformance: Model

    func validate() throws -> Self {
        guard useCases != nil, transformer != nil, state != nil
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
            do {
                switch event {
                case .didAppear:
                    break
                case .didToggleIsHuman(let index, let isHuman):
                    var players = state?.players
                    players?[index].isHuman = isHuman
                    
                    guard let players,
                          let newState = try? NewGame.State.Builder.with(base: state).with(players: players).build()
                    else { return }
                    
                    self.state = newState
                case .didUpdateName(let index, let name):
                    var players = state?.players
                    players?[index].name = name
                    
                    guard let players,
                          let newState = try? NewGame.State.Builder.with(base: state).with(players: players).build()
                    else { return }
                    
                    self.state = newState
                case .didTapStartGameButton:
                    guard let state,
                          let entity: GameEntity = try transformer?.transformToEntity(state)
                    else { Logger.default.logFatal("Unable to build game with input data") }
                    
                    uiRoutes?(.toGame(entity: entity))
                }
            } catch {
                Logger.default.logFatal("Error in NewGame.UIEvent - \(error)")
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

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(ID.self, forKey: .id)
        self.useCases = try values.decode(NewGame.UseCases.self, forKey: .useCases)
        self.transformer = try values.decode(NewGameTransformer.self, forKey: .transformer)
        self.uiRoutes = nil

        _ = try validate()
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

                state = newState
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

    func with(state: NewGame.State) -> GenericBuilder<NewGameViewModelImpl> {
        let newBase = NewGameViewModelImpl(base: base, state: state)
        return GenericBuilder<NewGameViewModelImpl>(base: newBase)
    }
}
