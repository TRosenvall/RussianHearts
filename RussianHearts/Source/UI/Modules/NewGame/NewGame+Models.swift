//
//  NewGame+Models.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import Foundation

///------

enum NewGame: ModuleModelBase {
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

extension NewGame {
    struct UseCases: Model {

        // MARK: - Properties

        typealias AssociatedEntity = NewGameEntity

        let id: UUID

        // MARK: - Lifecycle

        internal init(with base: NewGame.UseCases?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: NewGame.UseCases? = nil,
            id: UUID? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
        }

        // MARK: - Conformance: Model

        func validate() throws -> NewGame.UseCases {
            return self
        }
    }
}

extension GenericBuilder where T == NewGame.UseCases {}

///------

extension NewGame {
    struct State: Model {

        // MARK: - Properties

        typealias AssociatedEntity = NewGameEntity

        let id: UUID
        let isLoading: Bool?
        let gameEntity: GameEntity?
        let alerts: NewGame.State.Alerts?

        var gameEntityExists: Bool {
            return gameEntity != nil
        }

        // MARK: - Lifecycle

        internal init(with base: NewGame.State?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: NewGame.State? = nil,
            id: UUID? = nil,
            isLoading: Bool? = nil,
            gameEntity: GameEntity? = nil,
            alerts: NewGame.State.Alerts? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.isLoading = isLoading ?? base?.isLoading ?? false
            self.gameEntity = gameEntity ?? base?.gameEntity
            self.alerts = alerts ?? base?.alerts
        }

        // MARK: - Conformance: Model

        func validate() throws -> NewGame.State {
            guard isLoading != nil, alerts != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == NewGame.State {
    func with(isLoading: Bool) -> GenericBuilder<NewGame.State> {
        let newBase = NewGame.State(base: base, isLoading: isLoading)
        return GenericBuilder<NewGame.State>(base: newBase)
    }

    func with(gameEntity: GameEntity?) -> GenericBuilder<NewGame.State> {
        let newBase = NewGame.State(base: base, gameEntity: gameEntity)
        return GenericBuilder<NewGame.State>(base: newBase)
    }

    func with(alerts: NewGame.State.Alerts) -> GenericBuilder<NewGame.State> {
        let newBase = NewGame.State(base: base, alerts: alerts)
        return GenericBuilder<NewGame.State>(base: newBase)
    }
}

///------

extension NewGame.State {
    struct Alerts: Model {

        // MARK: - Properties

        typealias AssociatedEntity = NewGameEntity

        let id: UUID
        let isShowingErrorAlert: Bool?

        // MARK: - Lifecycle

        internal init(with base: NewGame.State.Alerts?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: NewGame.State.Alerts? = nil,
            id: UUID? = nil,
            isShowingErrorAlert: Bool? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.isShowingErrorAlert = isShowingErrorAlert ?? base?.isShowingErrorAlert ?? false
        }

        // MARK: - Conformance: Model

        func validate() throws -> NewGame.State.Alerts {
            guard isShowingErrorAlert != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == NewGame.State.Alerts {
    func with(isShowingErrorAlert: Bool) -> GenericBuilder<NewGame.State.Alerts> {
        let newBase = NewGame.State.Alerts(base: base, isShowingErrorAlert: isShowingErrorAlert)
        return GenericBuilder<NewGame.State.Alerts>(base: newBase)
    }
}
