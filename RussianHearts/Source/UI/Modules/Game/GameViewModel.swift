//
//  GameViewModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import SwiftUI

protocol GameViewModel: ModuleViewModel, ObservableObject where UIEvent == Game.UIEvent {
    
    var uiState: Game.State? { get }
    var gameState: GameState? { get }
}

class GameViewModelImpl:
    GameViewModel,
    LoadSavedDataOutput
{

    // MARK: - Types

    typealias ModuleError = Game.ModuleError
    typealias UIRoute = Game.UIRoute
    typealias ModuleState = Game.State
    typealias AssociatedEntity = GameEntity

    // MARK: - Properties

    let id: UUID
    let gameService: GameService?
    @Published var gameState: GameState?
    @Published var uiState: Game.State?

    let uiRoutes: ((Game.UIRoute, (any ModuleController)?) -> ())?
    let useCases: Game.UseCases?
    let transformer: GameTransformer?

    // A reference the the hosting controller
    var hostRef: (any GameHost)?

    // MARK: - Lifecycle

    required internal convenience init(with base: GameViewModelImpl?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: GameViewModelImpl? = nil,
        id: UUID? = nil,
        gameService: GameService? = nil,
        uiRoutes: ((Game.UIRoute, (any ModuleController)?) -> ())? = nil,
        useCases: Game.UseCases? = nil,
        transformer: GameTransformer? = nil,
        uiState: Game.State? = nil,
        gameState: GameState? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.gameService = gameService ?? base?.gameService
        self.uiRoutes = uiRoutes ?? base?.uiRoutes
        self.useCases = useCases ?? base?.useCases
        self.transformer = transformer ?? base?.transformer
        self.uiState = uiState ?? base?.uiState
        self.gameState = gameState ?? base?.gameState
    }

    // MARK: - Conformance: Model

    func validate() throws -> Self {
        guard useCases != nil, transformer != nil, uiState != nil, gameState != nil
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

    // MARK: - Conformance: GameViewModel

    func handleUIEvent(_ event: Game.UIEvent) {
        Logger.default.log("Handling \(event) Event")

        Task { @MainActor in
            do {
                switch event {
                // Lifecycle
                case .didAppear:
                    try gameService?.executeUseCase(
                        for: .startNewGame,
                        completion: { result in
                            switch result {
                            default:
                                Logger.default.log("Finished Start New Game Use Case", logType: .warn)
                            }
                    })
                // Back Button
                case .didTapBack:
                    uiState?.alerts?.isShowingBackButtonAlert = true
                case .didTapReturnToMainMenu(let entity):
                    uiRoutes?(.toMainMenu(entity: entity), hostRef)
                case .didTapReturnToGame:
                    uiState?.alerts?.isShowingBackButtonAlert = false
                // Game
                case .didTapCard(let cardView):
                    switch (cardView.tappedState, cardView.selectedState) {
                    // Raise Card To Tapped Position
                    case (.notTapped, .notSelected):
                        cardView.tappedState = .tapped
                    // Lower Card To Untapped Position
                    case (.tapped, .notSelected):
                        cardView.tappedState = .notTapped
                    // Break If Card Is Selected
                    default: break
                    }
                case .didTapPlayArea(cardView: let cardView):
                    switch (cardView.tappedState, cardView.selectedState) {
                    // Raise Card To Selected Position
                    case (.tapped, .notSelected):
                        cardView.selectedState = .selected
                    // Lower Card To Unselected Position
                    case (.tapped, .selected):
                        cardView.selectedState = .notSelected
                    // Break If Card Is Not Tapped
                    default: break
                    }
                case .didTapEndTurn:
                    // Call Game Service to Handle End Turn Use Case
                    uiState?.alerts?.isShowingNextTurnAlert = true
                case .didTapStartTurn:
                    // Call Game Service To Handle New Turn Use Case
                    uiState?.alerts?.isShowingNextTurnAlert = false
                case .gameDidFinish:
                    uiState?.alerts?.isShowingEndGameAlert = true
                case .didTapEndGame(let entity):
                    uiRoutes?(.toHighScores(entity: entity), hostRef)
                }
            } catch {
                Logger.default.logFatal("Error in Game.UIEvent - \(error)")
            }
        }
    }

    func handleError(_ error: Game.ModuleError) {
        Logger.default.log("Handing \(error) Error")

        Task { @MainActor in
            switch error {
            case .failed:
                print("Failed")
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
        case gameService
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(ID.self, forKey: .id)
        self.useCases = try values.decode(Game.UseCases.self, forKey: .useCases)
        self.transformer = try values.decode(GameTransformer.self, forKey: .transformer)
        self.gameService = try values.decode(GameService.self, forKey: .gameService)
        self.uiRoutes = nil

        _ = try validate()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(useCases, forKey: .useCases)
        try container.encode(transformer, forKey: .transformer)
        try container.encode(gameService, forKey: .gameService)
    }

    // MARK: - Helpers

    private func handleGetActiveEntity(_ result: Global.GetActiveEntityUseCaseResult<GameEntity>) {
        Logger.default.log("Handling Get Active Entity Use Case Result")

//        Task { @MainActor in
//            do {
//                switch result {
//                case .success(let newGameEntity):
//                    if let oldStates = newGameEntity.states {
//                        let newState = try Game.State.Builder
//                            .with(base: newGameEntity.states?.last)
//                            .with(isLoading: false)
//                            .build()
//
//                        let entity = try GameEntity.Builder
//                            .with(base: newGameEntity)
//                            .with(states: oldStates + [newState])
//                            .build()
//
//                        try Global.updateEntity(entity, completion: handleUpdateEntity)
//                    }
//                case .error(let error): Logger.default.log(error.localizedDescription, logType: .warn)
//                }
//            } catch {
//                Logger.default.log("Unable To Build New Entity", logType: .warn)
//            }
//        }
    }

    private func handleUpdateEntity(_ result: Global.UpdateEntityUseCaseResult) {
        Logger.default.log("Handling Update Entity Use Case Result")

        Task { @MainActor in
            switch result {
            case .success(let updatedEntity):
                guard let entity = updatedEntity as? GameEntity,
                      let newState = entity.gameStates?.last
                else {
                    Logger.default.log("Entity Did Not Update", logType: .warn)
                    return
                }

//                state = newState
            case .error(let error): Logger.default.log(error.localizedDescription, logType: .warn)
            }
        }
    }
}

extension GenericBuilder where T == GameViewModelImpl {
    func with(transformer: GameTransformer) -> GenericBuilder<GameViewModelImpl> {
        let newBase = GameViewModelImpl(base: base, transformer: transformer)
        return GenericBuilder<GameViewModelImpl>(base: newBase)
    }

    func with(useCases: Game.UseCases) -> GenericBuilder<GameViewModelImpl> {
        let newBase = GameViewModelImpl(base: base, useCases: useCases)
        return GenericBuilder<GameViewModelImpl>(base: newBase)
    }

    func with(uiRoutes: ((Game.UIRoute, (any ModuleController)?) -> ())?) -> GenericBuilder<GameViewModelImpl> {
        let newBase = GameViewModelImpl(base: base, uiRoutes: uiRoutes)
        return GenericBuilder<GameViewModelImpl>(base: newBase)
    }

    func with(uiState: Game.State) -> GenericBuilder<GameViewModelImpl> {
        let newBase = GameViewModelImpl(base: base, uiState: uiState)
        return GenericBuilder<GameViewModelImpl>(base: newBase)
    }

    func with(gameState: GameState) -> GenericBuilder<GameViewModelImpl> {
        let newBase = GameViewModelImpl(base: base, gameState: gameState)
        return GenericBuilder<GameViewModelImpl>(base: newBase)
    }

    func with(gameService: GameService) -> GenericBuilder<GameViewModelImpl> {
        let newBase = GameViewModelImpl(base: base, gameService: gameService)
        return GenericBuilder<GameViewModelImpl>(base: newBase)
    }
}
