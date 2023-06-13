//
//  NumberCard.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import UIKit

enum CardValues: Int {
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
enum CardSuit: String {
    case sickles = "green"
    case swords = "red"
    case crosses = "yellow"
    case crowns = "blue"
}

class NumberCard: Card {
    var value: CardValues
    var suit: CardSuit
    var image: UIImage

    init(value: CardValues,
         suit: CardSuit,
         image: UIImage) {
        self.value = value
        self.suit = suit
        self.image = image
    }
}
