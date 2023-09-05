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

enum CardState {
    case tapped
    case notTapped
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

    var state: CardState = .notTapped
}
