//
//  NewGameEntity.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import Foundation

struct NewGameEntity: Entity {

    // MARK: - Properties

    typealias ModuleState = NewGame.State
    typealias AssociatedEntity = Self

    static var persistID: String = "com.russianhearts.newgameentity"

    let id: UUID
    let gameStates: [NewGame.State]?
    let completionState: CompletionState?

    // MARK: - Lifecycle

    internal init(with base: NewGameEntity?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: NewGameEntity? = nil,
        id: UUID? = nil,
        states: [NewGame.State]? = nil,
        completionState: CompletionState? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.gameStates = states ?? base?.gameStates
        self.completionState = completionState ?? base?.completionState
    }

    // MARK: - Conformance: Model

    func validate() throws -> NewGameEntity {
        guard gameStates != nil, completionState != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

extension GenericBuilder where T == NewGameEntity {
    func with(states: [NewGame.State]) -> GenericBuilder<NewGameEntity> {
        let newBase = NewGameEntity(base: base, states: states)
        return GenericBuilder<NewGameEntity>(base: newBase)
    }

    func with(completionState: CompletionState) -> GenericBuilder<NewGameEntity> {
        let newBase = NewGameEntity(base: base, completionState: completionState)
        return GenericBuilder<NewGameEntity>(base: newBase)
    }
}
