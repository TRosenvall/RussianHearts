//
//  MainMenu+Models.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import Foundation

///------

enum MainMenu: ModuleModelBase {
    enum ModuleError: Error, Equatable {
        case failed
        case noSavedGamesFound
    }
    
    enum UIEvent: Equatable {
        case didAppear
        case didTapNewGame
        case didTapContinueGame(entity: GameEntity?)
        case didTapRules
        case didTapHighscores
        case didTapFriends
        case didTapSettings
    }
    
    enum UIRoute: Equatable, Codable {
        case toNewGame
        case toContinueGame(entity: GameEntity?)
        case toRules
        case toHighscores
        case toFriends
        case toSettings
    }
}

///------

extension MainMenu {
    struct UseCases: Model {

        // MARK: - Properties

        typealias AssociatedEntity = MainMenuEntity

        let id: UUID

        // MARK: - Lifecycle

        internal init(with base: MainMenu.UseCases?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: MainMenu.UseCases? = nil,
            id: UUID? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
        }

        // MARK: - Conformance: Model

        func validate() throws -> MainMenu.UseCases {
            return self
        }
    }
}

extension GenericBuilder where T == MainMenu.UseCases {}

///------

extension MainMenu {
    struct State: Model {

        // MARK: - Properties

        typealias AssociatedEntity = MainMenuEntity

        let id: UUID
        let isLoading: Bool?
        let gameEntity: GameEntity?
        let alerts: MainMenu.State.Alerts?

        var gameEntityExists: Bool {
            return gameEntity != nil
        }

        // MARK: - Lifecycle

        internal init(with base: MainMenu.State?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: MainMenu.State? = nil,
            id: UUID? = nil,
            isLoading: Bool? = nil,
            gameEntity: GameEntity? = nil,
            alerts: MainMenu.State.Alerts? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.isLoading = isLoading ?? base?.isLoading ?? false
            self.gameEntity = gameEntity ?? base?.gameEntity
            self.alerts = alerts ?? base?.alerts
        }

        // MARK: - Conformance: Model

        func validate() throws -> MainMenu.State {
            guard isLoading != nil, alerts != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == MainMenu.State {
    func with(isLoading: Bool) -> GenericBuilder<MainMenu.State> {
        let newBase = MainMenu.State(base: base, isLoading: isLoading)
        return GenericBuilder<MainMenu.State>(base: newBase)
    }

    func with(gameEntity: GameEntity?) -> GenericBuilder<MainMenu.State> {
        let newBase = MainMenu.State(base: base, gameEntity: gameEntity)
        return GenericBuilder<MainMenu.State>(base: newBase)
    }

    func with(alerts: MainMenu.State.Alerts) -> GenericBuilder<MainMenu.State> {
        let newBase = MainMenu.State(base: base, alerts: alerts)
        return GenericBuilder<MainMenu.State>(base: newBase)
    }
}

///------

extension MainMenu.State {
    struct Alerts: Model {

        // MARK: - Properties

        typealias AssociatedEntity = MainMenuEntity

        let id: UUID
        let isShowingErrorAlert: Bool?

        // MARK: - Lifecycle

        internal init(with base: MainMenu.State.Alerts?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: MainMenu.State.Alerts? = nil,
            id: UUID? = nil,
            isShowingErrorAlert: Bool? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.isShowingErrorAlert = isShowingErrorAlert ?? base?.isShowingErrorAlert ?? false
        }

        // MARK: - Conformance: Model

        func validate() throws -> MainMenu.State.Alerts {
            guard isShowingErrorAlert != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == MainMenu.State.Alerts {
    func with(isShowingErrorAlert: Bool) -> GenericBuilder<MainMenu.State.Alerts> {
        let newBase = MainMenu.State.Alerts(base: base, isShowingErrorAlert: isShowingErrorAlert)
        return GenericBuilder<MainMenu.State.Alerts>(base: newBase)
    }
}
