//
//  Game+Models.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import Foundation

///------

enum Game: ModuleModelBase {
    enum ModuleError: Error, Equatable {
        case failed
    }
    
    enum UIEvent: Equatable {

        // Lifecycle
        case didAppear

        // Back Button
        case didTapBack
        case didTapReturnToMainMenu(gameEntity: GameEntity)
        case didTapReturnToGame

        // Game Play
        case didTapCard(cardView: CardView) // Moves the card up and down based on whether or not the card is tapped
        case didTapPlayArea(cardView: CardView) // Moves the card to the play area based on whether or not the card is selected
        case didTapEndTurn // Moves to the next players turn and shows the Next Turn Alert Popup
        case didTapStartTurn // Removes the Next Turn Alert Popup
        case gameDidFinish // Shows the End Game Alert Popup
        case didTapEndGame(gameEntity: GameEntity) // Routes to Highscore Module from End Game Alert Popup
    }
    
    enum UIRoute: Equatable, Codable {
        case toMainMenu(entity: GameEntity)
        case toHighScores(entity: GameEntity)
    }
}

///------

extension Game {
    struct UseCases: Model {

        // MARK: - Properties

        typealias AssociatedEntity = GameEntity

        let id: UUID

        // MARK: - Lifecycle

        internal init(with base: Game.UseCases?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: Game.UseCases? = nil,
            id: UUID? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
        }

        // MARK: - Conformance: Model

        func validate() throws -> Game.UseCases {
            return self
        }
    }
}

extension GenericBuilder where T == Game.UseCases {}

///------

extension Game {
    struct State: Model {

        // MARK: - Properties

        typealias AssociatedEntity = GameEntity

        let id: UUID
        let isLoading: Bool?
        let gameEntity: GameEntity?
        var alerts: Game.State.Alerts?

        // MARK: - Lifecycle

        internal init(with base: Game.State?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: Game.State? = nil,
            id: UUID? = nil,
            isLoading: Bool? = nil,
            gameEntity: GameEntity? = nil,
            alerts: Game.State.Alerts? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.isLoading = isLoading ?? base?.isLoading ?? false
            self.gameEntity = gameEntity ?? base?.gameEntity
            self.alerts = alerts ?? base?.alerts
        }

        // MARK: - Conformance: Model

        func validate() throws -> Self {
            guard isLoading != nil, alerts != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == Game.State {
    func with(isLoading: Bool) -> GenericBuilder<Game.State> {
        let newBase = Game.State(base: base, isLoading: isLoading)
        return GenericBuilder<Game.State>(base: newBase)
    }

    func with(gameEntity: GameEntity?) -> GenericBuilder<Game.State> {
        let newBase = Game.State(base: base, gameEntity: gameEntity)
        return GenericBuilder<Game.State>(base: newBase)
    }

    func with(alerts: Game.State.Alerts) -> GenericBuilder<Game.State> {
        let newBase = Game.State(base: base, alerts: alerts)
        return GenericBuilder<Game.State>(base: newBase)
    }
}

///------

extension Game.State {
    struct Alerts: Model {

        // MARK: - Properties

        typealias AssociatedEntity = GameEntity

        let id: UUID
        var isShowingErrorAlert: Bool?
        var isShowingBackButtonAlert: Bool?
        var isShowingNextTurnAlert: Bool?
        var isShowingEndGameAlert: Bool?

        // MARK: - Lifecycle

        internal init(with base: Game.State.Alerts?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: Game.State.Alerts? = nil,
            id: UUID? = nil,
            isShowingErrorAlert: Bool? = nil,
            isShowingBackButtonAlert: Bool? = nil,
            isShowingNextTurnAlert: Bool? = nil,
            isShowingEndGameAlert: Bool? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.isShowingErrorAlert = isShowingErrorAlert ?? base?.isShowingErrorAlert ?? false
            self.isShowingBackButtonAlert = isShowingBackButtonAlert ?? base?.isShowingBackButtonAlert ?? false
            self.isShowingNextTurnAlert = isShowingNextTurnAlert ?? base?.isShowingNextTurnAlert ?? false
            self.isShowingEndGameAlert = isShowingEndGameAlert ?? base?.isShowingEndGameAlert ?? false
        }

        // MARK: - Conformance: Model

        func validate() throws -> Game.State.Alerts {
            guard 
                isShowingErrorAlert != nil,
                isShowingBackButtonAlert != nil,
                isShowingNextTurnAlert != nil,
                isShowingEndGameAlert != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == Game.State.Alerts {
    func with(isShowingErrorAlert: Bool) -> GenericBuilder<Game.State.Alerts> {
        let newBase = Game.State.Alerts(base: base, isShowingErrorAlert: isShowingErrorAlert)
        return GenericBuilder<Game.State.Alerts>(base: newBase)
    }

    func with(isShowingBackButtonAlert: Bool) -> GenericBuilder<Game.State.Alerts> {
        let newBase = Game.State.Alerts(base: base, isShowingBackButtonAlert: isShowingBackButtonAlert)
        return GenericBuilder<Game.State.Alerts>(base: newBase)
    }

    func with(isShowingNextTurnAlert: Bool) -> GenericBuilder<Game.State.Alerts> {
        let newBase = Game.State.Alerts(base: base, isShowingNextTurnAlert: isShowingNextTurnAlert)
        return GenericBuilder<Game.State.Alerts>(base: newBase)
    }

    func with(isShowingEndGameAlert: Bool) -> GenericBuilder<Game.State.Alerts> {
        let newBase = Game.State.Alerts(base: base, isShowingEndGameAlert: isShowingEndGameAlert)
        return GenericBuilder<Game.State.Alerts>(base: newBase)
    }
}
