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

enum CardTappedState: Codable {
    case tapped
    case notTapped
}

enum CardSelectedState: Codable {
    case selected
    case notSelected
}

class CardView: UIView {
//
//    // MARK: - Properties
//    var card: Card
//    var delegate: CardViewDelegate? = nil
//
//    var cardRatio: CGFloat = 62.0/88.0
//
//    var _isUpsideDown: Bool = true
//    var isUpsideDown: Bool {
//        get {
//            return _isUpsideDown
//        }
//        set {
//            _isUpsideDown = newValue
//        }
//    }
//
//    var isDisabled: Bool {
//        get {
//            return card.isDisabled
//        }
//        set {
//            card.isDisabled = newValue
//        }
//    }
//
//    var tappedState: CardTappedState {
//        get {
//            return card.tappedState
//        }
//        set {
//            card.tappedState = newValue
//        }
//    }
//                                                                        
//    var selectedState: CardSelectedState {
//        get {
//            return card.selectedState
//        }
//        set {
//            card.selectedState = newValue
//        }
//    }
//
//    // MARK: - Lifecycle
//    init(card: Card) {
//        self.card = card
//        super.init(frame: CGRect())
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
