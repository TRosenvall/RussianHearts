//
//  Assets.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/14/23.
//

import UIKit

class Assets {

    // MARK: - Properties
    static let appIcon = UIImage(named: "AppIcon")
    static let accentColor = UIColor(named: "AccentColor")
    static let backgroundColor = UIColor(named: "BackgroundColor")

    static func image(from suit: CardSuit) -> UIImage {
        return UIImage(named: suit.rawValue)!
    }

    static func image(for specialCardName: String) -> UIImage {
        return UIImage(named: specialCardName) ?? UIImage()
    }

    static func secondaryImage(for specialCardType: SpecialCardType) -> UIImage? {
        var suit: CardSuit? = nil
        switch specialCardType {
        case SpecialCardType.lowCard: suit = .purple
        case SpecialCardType.highCard: suit = .red
        case SpecialCardType.lowJoker: suit = .brown
        case SpecialCardType.highJoker: suit = .blue
        }

        return Assets.image(from: suit!)
    }
}
