//
//  MainMenuViewModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import SwiftUI

protocol MainMenuViewModel: ModuleViewModel {
    var view: MainMenuViewImpl? { get }
}

struct MainMenuViewModelImpl:
    MainMenuViewModel,
    LoadSavedDataOutput
{

    // MARK: - Properties

    typealias UIEvent = MainMenu.UIEvent
    typealias ModuleError = MainMenu.ModuleError
    typealias UIRoute = MainMenu.UIRoute
    typealias ModuleState = MainMenu.State
    typealias AssociatedEntity = MainMenuEntity

    let id: UUID
    var view: MainMenuViewImpl?

    let uiRoutes: ((MainMenu.UIRoute) -> ())?
    let useCases: MainMenu.UseCases?
    let transformer: MainMenuTransformer?

    // MARK: - Lifecycle

    internal init(with base: MainMenuViewModelImpl?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: MainMenuViewModelImpl? = nil,
        id: UUID? = nil,
        uiRoutes: ((MainMenu.UIRoute) -> ())? = nil,
        useCases: MainMenu.UseCases? = nil,
        transformer: MainMenuTransformer? = nil,
        view: MainMenuViewImpl? = nil
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

    // MARK: - Conformance: MainMenuViewModel

    func handleUIEvent(_ event: MainMenu.UIEvent) {
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

    func handleError(_ error: MainMenu.ModuleError) {
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
        let useCases = try values.decode(MainMenu.UseCases.self, forKey: .useCases)
        let transformer = try values.decode(MainMenuTransformer.self, forKey: .transformer)
        let uiRoutes: ((MainMenu.UIRoute) -> ())? = nil
        self = try MainMenuViewModelImpl.Builder
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

    private func handleGetActiveEntity(_ result: Global.GetActiveEntityUseCaseResult<MainMenuEntity>) {
        Logger.default.log("Handling Get Active Entity Use Case Result")

        Task { @MainActor in
            do {
                switch result {
                case .success(let mainMenuEntity):
                    if let oldStates = mainMenuEntity.states {
                        let newState = try MainMenu.State.Builder
                            .with(base: mainMenuEntity.states?.last)
                            .with(isLoading: false)
                            .build()

                        let entity = try MainMenuEntity.Builder
                            .with(base: mainMenuEntity)
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
                guard let entity = updatedEntity as? MainMenuEntity,
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

extension GenericBuilder where T == MainMenuViewModelImpl {
    func with(transformer: MainMenuTransformer) -> GenericBuilder<MainMenuViewModelImpl> {
        let newBase = MainMenuViewModelImpl(base: base, transformer: transformer)
        return GenericBuilder<MainMenuViewModelImpl>(base: newBase)
    }

    func with(useCases: MainMenu.UseCases) -> GenericBuilder<MainMenuViewModelImpl> {
        let newBase = MainMenuViewModelImpl(base: base, useCases: useCases)
        return GenericBuilder<MainMenuViewModelImpl>(base: newBase)
    }

    func with(uiRoutes: ((MainMenu.UIRoute) -> ())?) -> GenericBuilder<MainMenuViewModelImpl> {
        let newBase = MainMenuViewModelImpl(base: base, uiRoutes: uiRoutes)
        return GenericBuilder<MainMenuViewModelImpl>(base: newBase)
    }

    func with(view: MainMenuViewImpl) -> GenericBuilder<MainMenuViewModelImpl> {
        let newBase = MainMenuViewModelImpl(base: base, view: view)
        return GenericBuilder<MainMenuViewModelImpl>(base: newBase)
    }
}
