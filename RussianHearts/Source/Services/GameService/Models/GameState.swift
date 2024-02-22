//
//  GameState.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

enum PhaseState: Codable {
    case inactive
    case active
    case complete
}

struct GameState: Model {

    // MARK: - Properties

    typealias AssociatedEntity = GameEntity

    let id: UUID
    let rounds: [Round]?
    let activeRound: Round?
    let players: [Player]?
    let endOfGame: Bool?
    let phaseState: PhaseState?
    let deck: DeckController?

    // MARK: - Lifecycle
    internal init(with base: GameState?, id: UUID?) {
        self.init(base: base, id: id)
    }

    init(base: GameState? = nil,
         id: UUID? = nil,
         rounds: [Round]? = nil,
         activeRound: Round? = nil,
         players: [Player]? = nil,
         endOfGame: Bool? = nil,
         phaseState: PhaseState? = nil,
         deck: DeckController? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.rounds = rounds ?? base?.rounds
        self.activeRound = activeRound ?? base?.activeRound
        self.players = players ?? base?.players
        self.endOfGame = endOfGame ?? base?.endOfGame
        self.phaseState = phaseState ?? base?.phaseState
        self.deck = deck ?? base?.deck
    }

    // MARK: - Helpers
    func validate() throws -> GameState {
        guard players != nil, endOfGame != nil, phaseState != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

// MARK: - Builder Extension
extension GenericBuilder where T == GameState {
    func with(rounds: [Round]) -> GenericBuilder<GameState> {
        let newBase = GameState(base: base, rounds: rounds)
        return GenericBuilder<GameState>(base: newBase)
    }

    func with(activeRound: Round) -> GenericBuilder<GameState> {
        let newBase = GameState(base: base, activeRound: activeRound)
        return GenericBuilder<GameState>(base: newBase)
    }

    func with(players: [Player]) -> GenericBuilder<GameState> {
        let newBase = GameState(base: base, players: players)
        return GenericBuilder<GameState>(base: newBase)
    }

    func isEndOfGame(_ endOfGame: Bool) -> GenericBuilder<GameState> {
        let newBase = GameState(base: base, endOfGame: endOfGame)
        return GenericBuilder<GameState>(base: newBase)
    }

    func with(phaseState: PhaseState) -> GenericBuilder<GameState> {
        let newBase = GameState(base: base, phaseState: phaseState)
        return GenericBuilder<GameState>(base: newBase)
    }

    func with(deck: DeckController) -> GenericBuilder<GameState> {
        let newBase = GameState(base: base, deck: deck)
        return GenericBuilder<GameState>(base: newBase)
    }
}

