//
//  LaunchEntity.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/15/24.
//

import Foundation

struct LaunchEntity: Entity {

    // MARK: - Properties

    typealias ModuleState = Launch.State
    typealias AssociatedEntity = Self

    static var persistID: String = "com.russianhearts.launchentity"

    let id: UUID
    let gameStates: [Launch.State]?
    let completionState: CompletionState?

    // MARK: - Lifecycle

    internal init(with base: LaunchEntity?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: LaunchEntity? = nil,
        id: UUID? = nil,
        states: [Launch.State]? = nil,
        completionState: CompletionState? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.gameStates = states ?? base?.gameStates
        self.completionState = completionState ?? base?.completionState
    }

    // MARK: - Conformance: Model

    func validate() throws -> LaunchEntity {
        guard gameStates != nil, completionState != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

extension GenericBuilder where T == LaunchEntity {
    func with(states: [Launch.State]) -> GenericBuilder<LaunchEntity> {
        let newBase = LaunchEntity(base: base, states: states)
        return GenericBuilder<LaunchEntity>(base: newBase)
    }

    func with(completionState: CompletionState) -> GenericBuilder<LaunchEntity> {
        let newBase = LaunchEntity(base: base, completionState: completionState)
        return GenericBuilder<LaunchEntity>(base: newBase)
    }
}
