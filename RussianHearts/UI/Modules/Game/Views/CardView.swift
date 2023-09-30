//
//  CardView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/2/23.
//

import UIKit

protocol CardViewDelegate {
    func tapped(_ cardView: CardView)
}

enum CardTappedState {
    case tapped
    case notTapped
}

enum CardSelectedState {
    case selected
    case notSelected
}

class CardView: UIView {

    // MARK: - Properties
    var delegate: CardViewDelegate? = nil

    var cardRatio: CGFloat = 62.0/88.0

    var _isUpsideDown: Bool = true
    var isUpsideDown: Bool {
        get {
            return _isUpsideDown
        }
        set {
            _isUpsideDown = newValue
        }
    }

    var tappedState: CardTappedState = .notTapped
    var selectedState: CardSelectedState = .notSelected
}
