//
//  HandView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/2/23.
//

import UIKit

class HandView: UIView, CardViewDelegate {

    // MARK: - Properties
    private var _player: PlayerModel? = nil
    var player: PlayerModel? {
        get {
            return _player
        }
        set {
            _player = newValue
            setupHandView()
        }
    }
    // Default color is black but should be updated immediately after initialization
    private var _moduleColor: UIColor = .black
    var moduleColor: UIColor {
        get {
            return _moduleColor
        }
        set {
            _moduleColor = newValue
            setupViews()
        }
    }

    var cardViews: [CardView] = []
    var downConstraints: [Int: NSLayoutConstraint] = [:]
    var upConstraints: [Int: NSLayoutConstraint] = [:]

    // MARK: - Views
    // Views
    lazy var backgroundBorderView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        return view
    }()

    lazy var backgroundColorView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundBorderView.addSubview(view)
        
        return view
    }()

    // MARK: - Lifecycle
    init() {
        super.init(frame: CGRect())

        self.translatesAutoresizingMaskIntoConstraints = false

        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Conformance: CardViewDelegate
    func tapped(_ cardView: CardView) {
        for otherCardView in cardViews {
            otherCardView.state = .notTapped
        }
        cardView.state = .tapped
        update(cardView)
    }

    // MARK: - Helpers
    func setupViews() {
        let borderWidth: CGFloat = 3

        // View
        self.backgroundColor = .white

        // Background Color View
        backgroundBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        // Figured these numbers out by guess and check, these should probably be formalized.
        backgroundBorderView.layer.borderColor = moduleColor.cgColor
        backgroundBorderView.layer.borderWidth = borderWidth

        // Background Color View
        backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        backgroundColorView.backgroundColor = moduleColor
        backgroundColorView.alpha = 0.001
    }

    func setupHandView() {
        guard let player else { return }
        let totalCards: CGFloat = CGFloat( player.cards.count )
        for i in 0..<Int(totalCards) {
            let card = player.cards[i]
            var cardView = CardView()

            if let card = card as? NumberCard {
                cardView = NumberCardView(card: card)
            }
            if let card = card as? SpecialCard {
                cardView = SpecialCardView(card: card)
            }

            cardView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(cardView)
            cardView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            cardView.widthAnchor.constraint(equalTo: cardView.heightAnchor,
                                            multiplier: cardView.cardRatio).isActive = true

            cardView.tag = i
            

            cardView.delegate = self

            layoutIfNeeded()

            let cardWidth = cardView.frame.width
            let handWidth: CGFloat = self.frame.width
            let spacer: CGFloat = cardWidth * 0.2
            let totalCardsLess1: CGFloat = totalCards - 1
            let j: CGFloat = CGFloat(i)

            let offsetPart1: CGFloat = totalCards * cardWidth
            let offsetPart2: CGFloat = totalCardsLess1 * spacer
            let offsetPart3: CGFloat = offsetPart1 + offsetPart2
            let offsetPart4: CGFloat = offsetPart3 - handWidth
            let offsetPart5: CGFloat = offsetPart4 / 2

            var offset: CGFloat = 0
            let offsetIsNeeded: Bool = offsetPart4 > 0
            if offsetIsNeeded {
                offset = offsetPart5 / (totalCards - 1)
            }

            let trueOffsetPart1: CGFloat = ( j - totalCards/2 ) * cardWidth
            let trueOffsetPart2: CGFloat = ( j + 1/2 - totalCards/2 ) * spacer
            let trueOffsetPart3: CGFloat = ( totalCardsLess1 - 2 * j ) * offset
            let trueOffset: CGFloat = trueOffsetPart1 + trueOffsetPart2 + trueOffsetPart3
            cardView.layer.cornerRadius = cardWidth/7
            cardView.isUpsideDown = false

            cardView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: trueOffset).isActive = true

            let cardHeight = cardView.frame.height

            let downConstraint = cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            downConstraints.updateValue(downConstraint, forKey: cardView.tag)
            downConstraint.isActive = true
            let upConstraint = cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                                constant:  -2/3 * cardHeight)
            upConstraints.updateValue(upConstraint, forKey: cardView.tag)
            cardViews.append(cardView)

            layoutIfNeeded()
        }
    }

    func update(_ cardView: CardView) {
        for otherCardViews in cardViews {
            let upConstraint = upConstraints[otherCardViews.tag]
            upConstraint?.isActive = false

            let downConstraint = downConstraints[otherCardViews.tag]
            downConstraint?.isActive = true
        }

        let downConstraint = downConstraints[cardView.tag]
        downConstraint?.isActive = false

        let upConstraint = upConstraints[cardView.tag]
        upConstraint?.isActive = true
        layoutIfNeeded()
    }

    func flipCards() {
        guard let player else { return }
        for card in player.cards {
            for view in self.subviews {
                if let view = view as? NumberCardView {
                    if view.card == card {
                        view.isUpsideDown = !view.isUpsideDown
                    }
                }
                if let view = view as? SpecialCardView {
                    if view.card == card {
                        view.isUpsideDown = !view.isUpsideDown
                    }
                }
            }
        }
        layoutIfNeeded()
    }
}
