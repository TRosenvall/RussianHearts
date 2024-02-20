//
//  Turn.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

// MARK: - Object
struct Turn: Model {

    // MARK: - Properties
    let id: UUID
    let activePlayer: Player?
    let phaseState: PhaseState?

    // MARK: - Lifecycle
    internal init(with base: Turn?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: Turn? = nil,
                     id: UUID? = nil,
                     activePlayer: Player? = nil,
                     phaseState: PhaseState? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.activePlayer = activePlayer ?? base?.activePlayer
        self.phaseState = phaseState ?? base?.phaseState
    }

    // MARK: - Helpers
    func validate() throws -> Turn {
        guard activePlayer != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

// MARK: - Builder
extension GenericBuilder where T == Turn {
    func with(activePlayer: Player) -> GenericBuilder<Turn> {
        let newBase = Turn(base: base, activePlayer: activePlayer)
        return GenericBuilder<Turn>(base: newBase)
    }

    func with(phaseState: PhaseState) -> GenericBuilder<Turn> {
        let newBase = Turn(base: base, phaseState: phaseState)
        return GenericBuilder<Turn>(base: newBase)
    }
}
