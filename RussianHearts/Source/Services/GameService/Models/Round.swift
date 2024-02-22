//
//  Round.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

struct Round: Model {

    // MARK: - Properties

    typealias AssociatedEntity = GameEntity

    let id: UUID
    let roundName: String?
    let numberOfCardsToPlay: Int?
    let bidsByPlayer: [Bid]?
    let trump: CardSuit?
    let tricks: [Trick]?
    let activeTrick: Trick?
    let phaseState: PhaseState?

    // MARK: - Lifecycle
    internal init(with base: Round?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: Round? = nil,
                     id: UUID? = nil,
                     roundName: String? = nil,
                     numberOfCardsToPlay: Int? = nil,
                     bidsByPlayer: [Bid]? = nil,
                     trump: CardSuit? = nil,
                     tricks: [Trick]? = nil,
                     activeTrick: Trick? = nil,
                     phaseState: PhaseState? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.roundName = roundName ?? base?.roundName
        self.numberOfCardsToPlay = numberOfCardsToPlay ?? base?.numberOfCardsToPlay
        self.bidsByPlayer = bidsByPlayer ?? base?.bidsByPlayer
        self.trump = trump ?? base?.trump
        self.tricks = tricks ?? base?.tricks
        self.activeTrick = activeTrick ?? base?.activeTrick
        self.phaseState = phaseState ?? base?.phaseState
    }

    // MARK: - Helpers
    func validate() throws -> Round {
        guard roundName != nil, numberOfCardsToPlay != nil, phaseState != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

// MARK: - Builder Extension
extension GenericBuilder where T == Round {
    func with(roundName: String) -> GenericBuilder<Round> {
        let newBase = Round(base: base, roundName: roundName)
        return GenericBuilder<Round>(base: newBase)
    }

    func with(numberOfCardsToPlay: Int) -> GenericBuilder<Round> {
        let newBase = Round(base: base, numberOfCardsToPlay: numberOfCardsToPlay)
        return GenericBuilder<Round>(base: newBase)
    }

    func with(bidsByPlayer: [Bid]) -> GenericBuilder<Round> {
        let newBase = Round(base: base, bidsByPlayer: bidsByPlayer)
        return GenericBuilder<Round>(base: newBase)
    }

    func with(trump: CardSuit) -> GenericBuilder<Round> {
        let newBase = Round(base: base, trump: trump)
        return GenericBuilder<Round>(base: newBase)
    }

    func with(tricks: [Trick]) -> GenericBuilder<Round> {
        let newBase = Round(base: base, tricks: tricks)
        return GenericBuilder<Round>(base: newBase)
    }

    func with(activeTrick: Trick) -> GenericBuilder<Round> {
        let newBase = Round(base: base, activeTrick: activeTrick)
        return GenericBuilder<Round>(base: newBase)
    }

    func with(phaseState: PhaseState) -> GenericBuilder<Round> {
        let newBase = Round(base: base, phaseState: phaseState)
        return GenericBuilder<Round>(base: newBase)
    }
}
