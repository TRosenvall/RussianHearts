//
//  SpecialCard.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import UIKit

enum SpecialCardType: String {
    case lowJoker
    case highJoker
    case lowCard
    case highCard
}

class SpecialCard: Card {
    var type: SpecialCardType
    var image: UIImage
    var name: String

    init(type: SpecialCardType, image: UIImage) {
        self.type = type
        self.image = image
        self.name = type.rawValue
    }
}
