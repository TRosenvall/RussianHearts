//
//  GameEntity.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

struct GameEntity: Entity {

    // MARK: - Properties

    typealias ModuleState = GameState
    typealias AssociatedEntity = Self

    static var persistID: String = "com.russianhearts.gameentity"

    let id: UUID
    let gameStates: [GameState]?
    let uiStates: [Game.State]?
    let completionState: CompletionState?

    // MARK: - Lifecycle

    internal init(with base: GameEntity?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: GameEntity? = nil,
                     id: UUID? = nil,
                     gameStates: [GameState]? = nil,
                     uiStates: [Game.State]? = nil,
                     completionState: CompletionState? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.gameStates = gameStates ?? base?.gameStates
        self.uiStates = uiStates ?? base?.uiStates
        self.completionState = completionState ?? base?.completionState
    }

    // MARK: - Helpers

    func validate() throws -> Self {
        guard gameStates != nil, completionState != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

extension GenericBuilder where T == GameEntity {
    func with(gameStates: [GameState]) -> GenericBuilder<GameEntity> {
        let newBase = GameEntity(base: base, gameStates: gameStates)
        return GenericBuilder<GameEntity>(base: newBase)
    }

    func with(uiStates: [Game.State]) -> GenericBuilder<GameEntity> {
        let newBase = GameEntity(base: base, uiStates: uiStates)
        return GenericBuilder<GameEntity>(base: newBase)
    }

    func with(completionState: CompletionState) -> GenericBuilder<GameEntity> {
        let newBase = GameEntity(base: base, completionState: completionState)
        return GenericBuilder<GameEntity>(base: newBase)
    }
}
