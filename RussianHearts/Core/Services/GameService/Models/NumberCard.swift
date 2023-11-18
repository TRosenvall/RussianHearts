//
//  NumberCard.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import UIKit

enum CardValues: Int, CaseIterable, Codable {
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
}

class NumberCard: Card {

    // MARK: - Properties
    var value: CardValues
    var suit: CardSuit

    // MARK: - Lifecycle
    init(value: CardValues,
         suit: CardSuit) {
        self.value = value
        self.suit = suit
        super.init()
    }

    // MARK: Conformance: Codable
    enum CodingKeys: CodingKey {
        case value
        case suit
        case id
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try values.decode(CardValues.self, forKey: .value)
        self.suit = try values.decode(CardSuit.self, forKey: .suit)
        try super.init(from: decoder)
    }
}
