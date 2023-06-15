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

    static func image(for specialCard: SpecialCardType) -> UIImage {
        return UIImage(named: specialCard.rawValue)!
    }
}
