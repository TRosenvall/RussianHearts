//
//  Player.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import Foundation

// MARK: - Object
struct Player: Model {

    // MARK: - Properties
    let id: UUID
    let name: String?
    let orderNumber: Int?
    let cards: [Card]?
    let activeBid: Bid?
    let currentScore: Int?
    let scoreTotal: Int?
    let isHuman: Bool?
    let hasPlayed: Bool?

    // MARK: - Lifecycle
    internal init(with base: Player?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: Player? = nil,
                     id: UUID? = nil,
                     name: String? = nil,
                     orderNumber: Int? = nil,
                     cards: [Card]? = nil,
                     activeBid: Bid? = nil,
                     currentScore: Int? = nil,
                     scoreTotal: Int? = nil,
                     isHuman: Bool? = nil,
                     hasPlayed: Bool? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.name = name ?? base?.name
        self.orderNumber = orderNumber ?? base?.orderNumber
        self.cards = cards ?? base?.cards
        self.activeBid = activeBid ?? base?.activeBid
        self.currentScore = currentScore ?? base?.currentScore
        self.scoreTotal = scoreTotal ?? base?.scoreTotal
        self.isHuman = isHuman ?? base?.isHuman
        self.hasPlayed = hasPlayed ?? base?.hasPlayed
    }

    // MARK: - Helpers
    func validate() throws -> Player {
        guard name != nil, isHuman != nil, hasPlayed != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

// MARK: - Builder Extension
extension GenericBuilder where T == Player {
    func with(name: String) -> GenericBuilder<Player> {
        let newBase = Player(base: base, name: name)
        return GenericBuilder<Player>(base: newBase)
    }

    func with(orderNumber: Int) -> GenericBuilder<Player> {
        let newBase = Player(base: base, orderNumber: orderNumber)
        return GenericBuilder<Player>(base: newBase)
    }

    func with(cards: [Card]) -> GenericBuilder<Player> {
        let newBase = Player(base: base, cards: cards)
        return GenericBuilder<Player>(base: newBase)
    }

    func with(activeBid: Bid) -> GenericBuilder<Player> {
        let newBase = Player(base: base, activeBid: activeBid)
        return GenericBuilder<Player>(base: newBase)
    }
    
    func with(currentScore: Int) -> GenericBuilder<Player> {
        let newBase = Player(base: base, currentScore: currentScore)
        return GenericBuilder<Player>(base: newBase)
    }
    
    func with(scoreTotal: Int) -> GenericBuilder<Player> {
        let newBase = Player(base: base, scoreTotal: scoreTotal)
        return GenericBuilder<Player>(base: newBase)
    }
    
    func isHuman(_ isHuman: Bool) -> GenericBuilder<Player> {
        let newBase = Player(base: base, isHuman: isHuman)
        return GenericBuilder<Player>(base: newBase)
    }
    
    func hasPlayed(_ hasPlayed: Bool) -> GenericBuilder<Player> {
        let newBase = Player(base: base, hasPlayed: hasPlayed)
        return GenericBuilder<Player>(base: newBase)
    }
}
