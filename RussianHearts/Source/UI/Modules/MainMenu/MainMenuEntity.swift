//
//  MainMenuEntity.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/15/24.
//

import Foundation

struct MainMenuEntity: Entity {

    // MARK: - Properties

    typealias ModuleState = MainMenu.State
    typealias AssociatedEntity = Self

    static var persistID: String = "com.russianhearts.mainmenuentity"

    let id: UUID
    let gameStates: [MainMenu.State]?
    let completionState: CompletionState?

    // MARK: - Lifecycle

    internal init(with base: MainMenuEntity?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: MainMenuEntity? = nil,
        id: UUID? = nil,
        states: [MainMenu.State]? = nil,
        completionState: CompletionState? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.gameStates = states ?? base?.gameStates
        self.completionState = completionState ?? base?.completionState
    }

    // MARK: - Conformance: Model

    func validate() throws -> MainMenuEntity {
        guard gameStates != nil, completionState != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

extension GenericBuilder where T == MainMenuEntity {
    func with(states: [MainMenu.State]) -> GenericBuilder<MainMenuEntity> {
        let newBase = MainMenuEntity(base: base, states: states)
        return GenericBuilder<MainMenuEntity>(base: newBase)
    }

    func with(completionState: CompletionState) -> GenericBuilder<MainMenuEntity> {
        let newBase = MainMenuEntity(base: base, completionState: completionState)
        return GenericBuilder<MainMenuEntity>(base: newBase)
    }
}
