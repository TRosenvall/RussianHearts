//
//  Trick.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/18/23.
//

import Foundation

struct Trick: Model {

    // MARK: - Properties

    let id: UUID
    let turns: [Turn]?
    let activeTurn: Turn?
    let cardsPlayed: [Card]?
    let players: [Player]?
    let firstPlayerId: UUID?
    let passesForward: Bool?
    let phaseState: PhaseState?

    // MARK: - Lifecycle

    internal init(with base: Trick?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: Trick? = nil,
                     id: UUID? = nil,
                     turns: [Turn]? = nil,
                     activeTurn: Turn? = nil,
                     cardsPlayed: [Card]? = nil,
                     players: [Player]? = nil,
                     firstPlayerId: UUID? = nil,
                     passesForward: Bool? = nil,
                     phaseState: PhaseState? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.turns = turns ?? base?.turns
        self.activeTurn = activeTurn ?? base?.activeTurn
        self.cardsPlayed = cardsPlayed ?? base?.cardsPlayed
        self.players = players ?? base?.players
        self.firstPlayerId = firstPlayerId ?? base?.firstPlayerId
        self.passesForward = passesForward ?? base?.passesForward
        self.phaseState = phaseState ?? base?.phaseState
    }

    // MARK: - Helpers

    func validate() throws -> Trick {
        guard phaseState != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

extension GenericBuilder where T == Trick {
    func with(turns: [Turn]) -> GenericBuilder<Trick> {
        let newBase = Trick(base: base, turns: turns)
        return GenericBuilder<Trick>(base: newBase)
    }

    func with(activeTurn: Turn?) -> GenericBuilder<Trick> {
        let newBase = Trick(base: base, activeTurn: activeTurn)
        return GenericBuilder<Trick>(base: newBase)
    }

    func with(cardsPlayed: [Card]) -> GenericBuilder<Trick> {
        let newBase = Trick(base: base, cardsPlayed: cardsPlayed)
        return GenericBuilder<Trick>(base: newBase)
    }

    func with(players: [Player]) -> GenericBuilder<Trick> {
        let newBase = Trick(base: base, players: players)
        return GenericBuilder<Trick>(base: newBase)
    }

    func with(firstPlayerId: UUID) -> GenericBuilder<Trick> {
        let newBase = Trick(base: base, firstPlayerId: firstPlayerId)
        return GenericBuilder<Trick>(base: newBase)
    }

    func passesForward(_ passesForward: Bool?) -> GenericBuilder<Trick> {
        let newBase = Trick(base: base, passesForward: passesForward)
        return GenericBuilder<Trick>(base: newBase)
    }

    func with(phaseState: PhaseState) -> GenericBuilder<Trick> {
        let newBase = Trick(base: base, phaseState: phaseState)
        return GenericBuilder<Trick>(base: newBase)
    }
}
