//
//  NumberCards.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 12/24/23.
//

import UIKit

enum CardValue: Int, CaseIterable, Codable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case eleven = 11
    case twelve = 12
    case thirteen = 13
    case fourteen = 14
}

// Raw value is the card tint color
enum CardSuit: String, CaseIterable, Codable {
    case purple = "Purple"
    case red = "Red"
    case brown = "Brown"
    case blue = "Blue"

    func transformToColor() -> UIColor {
        switch self {
        case .red: return .red
        case .purple: return .purple
        case .brown: return .brown
        case .blue: return .blue
        }
    }
}

struct NumberCard: CardProtocol {

    // MARK: - Properties

    typealias AssociatedEntity = GameEntity

    let id: UUID
    let value: CardValue?
    let suit: CardSuit?
    let playedBy: Player?

    // MARK: - Lifecycle
    internal init(with base: NumberCard?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: NumberCard? = nil,
                     id: UUID? = nil,
                     value: CardValue? = nil,
                     suit: CardSuit? = nil,
                     playedBy player: Player? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.value = value ?? base?.value
        self.suit = suit ?? base?.suit
        self.playedBy = player ?? base?.playedBy
    }

    // MARK: - Helpers
    func validate() throws -> NumberCard {
        guard value != nil, suit != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }

    func wrap() -> Card {
        return .number(card: self)
    }
}

enum NumberCardSortOption {
    case cardSuit
    case cardValue
}

extension Array where Element == NumberCard {
    func sort(by sortOption: NumberCardSortOption) throws -> [NumberCard] {
        switch sortOption {
        case .cardSuit: return try sortByCardSuit()
        case .cardValue: return try sortByCardValue()
        }
    }

    private func sortByCardValue() throws -> [NumberCard] {
        let sortedCards = try self.sorted { firstCard, secondCard in
            guard let firstCardValue = firstCard.value
            else { throw ModelError.requiredModelPropertiesNotSet(onType: CardValue.self) }

            guard let secondCardValue = secondCard.value
            else { throw ModelError.requiredModelPropertiesNotSet(onType: CardValue.self) }

            return firstCardValue.rawValue < secondCardValue.rawValue
        }

        return sortedCards
    }

    private func sortByCardSuit() throws -> [NumberCard] {
        let sortedCards = try self.sorted { firstCard, secondCard in
            guard let firstCardSuit = firstCard.suit
            else { throw ModelError.requiredModelPropertiesNotSet(onType: CardSuit.self) }

            guard let secondCardSuit = secondCard.suit
            else { throw ModelError.requiredModelPropertiesNotSet(onType: CardSuit.self) }

            return transform(firstCardSuit).rawValue < transform(secondCardSuit).rawValue
        }

        return sortedCards
    }

    private enum SuitNumber: Int {
        case red = 1
        case blue = 2
        case brown = 3
        case purple = 4
    }

    private func transform(_ cardSuit: CardSuit) -> SuitNumber {
        switch cardSuit {
        case .red: return .red
        case .blue: return .blue
        case .brown: return .brown
        case .purple: return .purple
        }
    }
}

// MARK: - Number Card Builder
extension GenericBuilder where T == NumberCard {
    func with(value: CardValue) -> GenericBuilder<NumberCard> {
        let newBase = NumberCard(base: base, value: value)
        return GenericBuilder<NumberCard>(base: newBase)
    }

    func with(suit: CardSuit) -> GenericBuilder<NumberCard> {
        let newBase = NumberCard(base: base, suit: suit)
        return GenericBuilder<NumberCard>(base: newBase)
    }

    func playedBy(_ player: Player) -> GenericBuilder<NumberCard> {
        let newBase = NumberCard(base: base, playedBy: player)
        return GenericBuilder<NumberCard>(base: newBase)
    }
}
