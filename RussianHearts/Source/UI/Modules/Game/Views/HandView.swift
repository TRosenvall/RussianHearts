////
////  HandView.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 9/2/23.
////
//
//import UIKit
//
//protocol HandViewDelegate {
//    func playAreaTapped()
//
//    func getActivePlayer() -> Player
//
//    func getPlayedCards() -> [Card]
//
//    func getPlayerIdForFirstPlayerThisPhase() -> Int
//
//    func getPlayers() -> [Player]
//
//    func getTrump() -> CardSuit
//
//    func getSuitPlayedFirst() -> CardSuit?
//
//    func playerHasSuitInHand(_ player: Player,
//                             suit: CardSuit?) -> Bool
//
//    func isSuit(for card: NumberCard, suit: CardSuit?) -> Bool
//
//    func isPassingPhase() -> Bool
//}
//
//class HandView: UIView, CardViewDelegate {
//
//    // MARK: - Properties
//    var delegate: HandViewDelegate?
//    private var _player: Player? = nil
//    var player: Player? {
//        get {
//            return _player
//        }
//        set {
//            _player = newValue
//            setupHandView()
//        }
//    }
//    // Default color is black but should be updated immediately after initialization
//    private var _moduleColor: UIColor = .black
//    var moduleColor: UIColor {
//        get {
//            return _moduleColor
//        }
//        set {
//            _moduleColor = newValue
//            setupViews()
//        }
//    }
//
//    var cardViews: [CardView] = []
//    var downConstraints: [Int: NSLayoutConstraint] = [:]
//    var upConstraints: [Int: NSLayoutConstraint] = [:]
//
//    var topConstraints: [Int: NSLayoutConstraint] = [:]
//    var defaultLeadingConstraints: [Int: NSLayoutConstraint] = [:]
//    var placeholderLeadingConstraints: [Int: NSLayoutConstraint] = [:]
//
//    var isSelected: Bool {
//        for cardView in cardViews where cardView.selectedState == .selected {
//            return true
//        }
//        return false
//    }
//
//    // MARK: - Views
//    // Views
//    lazy var actualHolderView: UIView = {
//        let view = UIView()
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//        
//        return view
//    }()
//
//    lazy var backgroundBorderView: UIView = {
//        let view = UIView()
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        actualHolderView.addSubview(view)
//        
//        return view
//    }()
//
//    lazy var backgroundColorView: UIView = {
//        let view = UIView()
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        backgroundBorderView.addSubview(view)
//        
//        return view
//    }()
//
//    // Buttons
//    lazy var actualHolderViewButton: UIButton = {
//        let button = UIButton()
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(button)
//
//        button.addTarget(self,
//                         action: #selector(actualHolderViewButtonTapped),
//                         for: .touchUpInside)
//        return button
//    }()
//
//    // MARK: - Lifecycle
//    init() {
//        super.init(frame: CGRect())
//
//        self.translatesAutoresizingMaskIntoConstraints = false
//
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Actions
//
//    @objc func actualHolderViewButtonTapped() {
//        delegate?.playAreaTapped()
//    }
//
//    // MARK: - Conformance: CardViewDelegate
//    func tapped(_ cardView: CardView) {
//        if !isSelected {
//            let currentState = cardView.tappedState
//            
//            for otherCardView in cardViews {
//                otherCardView.tappedState = .notTapped
//            }
//            
//            switch currentState {
//            case .tapped: cardView.tappedState = .notTapped
//            case .notTapped: cardView.tappedState = .tapped
//            }
//            
//            for otherCardView in cardViews {
//                updateTapped(otherCardView)
//            }
//        }
//    }
//
//    // MARK: - Helpers
//    func setupViews() {
//        let borderWidth: CGFloat = 3
//
//        // View
//        self.backgroundColor = .clear
//
//        // Actual Holder View
//        actualHolderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        actualHolderView.heightAnchor.constraint(equalTo: self.heightAnchor,
//                                                 multiplier: 3/5).isActive = true
//        actualHolderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        actualHolderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        actualHolderView.backgroundColor = .white
//
//        // Background Color View
//        backgroundBorderView.topAnchor.constraint(equalTo: actualHolderView.topAnchor,
//                                                  constant: 0).isActive = true
//        backgroundBorderView.leadingAnchor.constraint(equalTo: actualHolderView.leadingAnchor,
//                                                      constant: -3).isActive = true
//        backgroundBorderView.trailingAnchor.constraint(equalTo: actualHolderView.trailingAnchor,
//                                                       constant: 3).isActive = true
//        backgroundBorderView.bottomAnchor.constraint(equalTo: actualHolderView.bottomAnchor,
//                                                     constant: 0).isActive = true
//        // Figured these numbers out by guess and check, these should probably be formalized.
//        backgroundBorderView.layer.borderColor = moduleColor.cgColor
//        backgroundBorderView.layer.borderWidth = borderWidth
//
//        // Background Color View
//        backgroundColorView.topAnchor.constraint(equalTo: backgroundBorderView.topAnchor,
//                                                 constant: 10).isActive = true
//        backgroundColorView.leadingAnchor.constraint(equalTo: backgroundBorderView.leadingAnchor,
//                                                     constant: 10).isActive = true
//        backgroundColorView.trailingAnchor.constraint(equalTo: backgroundBorderView.trailingAnchor,
//                                                      constant: 10).isActive = true
//        backgroundColorView.bottomAnchor.constraint(equalTo: backgroundBorderView.bottomAnchor,
//                                                    constant: 10).isActive = true
//        backgroundColorView.backgroundColor = moduleColor
//        backgroundColorView.alpha = 0.001
//
//        // Actual Holder View Button
//        actualHolderViewButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        actualHolderViewButton.bottomAnchor.constraint(equalTo: backgroundBorderView.topAnchor).isActive = true
//        actualHolderViewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        actualHolderViewButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        actualHolderViewButton.backgroundColor = .clear
//    }
//
//    func setupHandView() {
//        guard let delegate
//        else {
//            fatalError("Delegate not found, module resolving screwed up")
//        }
//
//        guard let player else { return }
//        let totalCards: CGFloat = CGFloat( player.cards.count )
//        for i in 0..<Int(totalCards) {
//            let card = player.cards[i]
//            var cardView: CardView?
//
//            if let card = card as? NumberCard {
//                cardView = NumberCardView(card: card)
//            }
//            if let card = card as? SpecialCard {
//                cardView = SpecialCardView(card: card)
//            }
//
//            guard let cardView
//            else { fatalError("Card View Failed Setup") }
//
//            cardView.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(cardView)
//            cardView.heightAnchor.constraint(equalTo: actualHolderView.heightAnchor).isActive = true
//            cardView.widthAnchor.constraint(equalTo: cardView.heightAnchor,
//                                            multiplier: cardView.cardRatio).isActive = true
//
//            cardView.tag = i
//            
//
//            cardView.delegate = self
//
//            layoutIfNeeded()
//
//            let cardWidth = cardView.frame.width
//            let handWidth: CGFloat = self.frame.width
//            let spacer: CGFloat = cardWidth * 0.2
//            let totalCardsLess1: CGFloat = totalCards - 1
//            let j: CGFloat = CGFloat(i)
//
//            let offsetPart1: CGFloat = totalCards * cardWidth
//            let offsetPart2: CGFloat = totalCardsLess1 * spacer
//            let offsetPart3: CGFloat = offsetPart1 + offsetPart2
//            let offsetPart4: CGFloat = offsetPart3 - handWidth
//            let offsetPart5: CGFloat = offsetPart4 / 2
//
//            var offset: CGFloat = 0
//            let offsetIsNeeded: Bool = offsetPart4 > 0
//            if offsetIsNeeded {
//                offset = offsetPart5 / (totalCards - 1)
//            }
//
//            let trueOffsetPart1: CGFloat = ( j - totalCards/2 ) * cardWidth
//            let trueOffsetPart2: CGFloat = ( j + 1/2 - totalCards/2 ) * spacer
//            let trueOffsetPart3: CGFloat = ( totalCardsLess1 - 2 * j ) * offset
//            let trueOffset: CGFloat = trueOffsetPart1 + trueOffsetPart2 + trueOffsetPart3
//            cardView.layer.cornerRadius = cardWidth/7
//            cardView.isUpsideDown = false
//
//            let defaultLeadingConstraint = cardView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: trueOffset)
//            defaultLeadingConstraints.updateValue(defaultLeadingConstraint, forKey: cardView.tag)
//            defaultLeadingConstraint.isActive = true
//
//            let cardHeight = cardView.frame.height
//
//            let downConstraint = cardView.bottomAnchor.constraint(equalTo: actualHolderView.bottomAnchor)
//            downConstraints.updateValue(downConstraint, forKey: cardView.tag)
//            downConstraint.isActive = true
//            let upConstraint = cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
//                                                                constant:  -2/3 * cardHeight)
//            upConstraints.updateValue(upConstraint, forKey: cardView.tag)
//            cardViews.append(cardView)
//
//            if let cardView = cardView as? NumberCardView,
//               let card = cardView.card as? NumberCard {
//                let activePlayer: Player = delegate.getActivePlayer()
//                let trumpSuit: CardSuit = delegate.getTrump()
//                let suitPlayedFirst = delegate.getSuitPlayedFirst()
//                let hasSuitInHand: Bool = delegate.playerHasSuitInHand(activePlayer,
//                                                                       suit: suitPlayedFirst)
//                let cardIsFirstSuit: Bool = delegate.isSuit(for: card,
//                                                            suit: suitPlayedFirst)
//
//                updateShouldBeDisabled(for: cardView,
//                                       trumpSuit: trumpSuit,
//                                       hasFirstSuit: hasSuitInHand,
//                                       currentCardIsFirstSuit: cardIsFirstSuit)
//            }
//
//            layoutIfNeeded()
//        }
//    }
//
//    func updateTapped(_ cardView: CardView) {
//        switch cardView.tappedState {
//        case .tapped:
//            let downConstraint = downConstraints[cardView.tag]
//            downConstraint?.isActive = false
//            
//            let upConstraint = upConstraints[cardView.tag]
//            upConstraint?.isActive = true
//        case .notTapped:
//            let upConstraint = upConstraints[cardView.tag]
//            upConstraint?.isActive = false
//            
//            let downConstraint = downConstraints[cardView.tag]
//            downConstraint?.isActive = true
//        }
//        layoutIfNeeded()
//    }
//
//    func updateSelected(_ cardView: CardView) {
//        switch cardView.selectedState {
//        case .selected:
//            let placeholderLeadingConstraint = placeholderLeadingConstraints[cardView.tag]
//            let placeholderTopConstraint = topConstraints[cardView.tag]
//            placeholderLeadingConstraint?.isActive = true
//            placeholderTopConstraint?.isActive = true
//
//            let defaultLeadingConstraint = defaultLeadingConstraints[cardView.tag]
//            let upConstraint = upConstraints[cardView.tag]
//            defaultLeadingConstraint?.isActive = false
//            upConstraint?.isActive = false
//
//            guard let delegate
//            else { fatalError("Delegate not properly configured") }
//
//            if delegate.isPassingPhase() {
//                cardView.isUpsideDown = true
//            } else {
//                cardView.isUpsideDown = false
//            }
//
//        case .notSelected:
//            let placeholderLeadingConstraint = placeholderLeadingConstraints[cardView.tag]
//            let placeholderTopConstraint = topConstraints[cardView.tag]
//            placeholderLeadingConstraint?.isActive = false
//            placeholderTopConstraint?.isActive = false
//
//            let defaultLeadingConstraint = defaultLeadingConstraints[cardView.tag]
//            let upConstraint = upConstraints[cardView.tag]
//            defaultLeadingConstraint?.isActive = true
//            upConstraint?.isActive = true
//
//            cardView.isUpsideDown = false
//        }
//
//        layoutIfNeeded()
//    }
//
//    func flipCards() {
//        guard let player else { return }
//        for card in player.cards {
//            for view in self.subviews {
//                if let view = view as? NumberCardView {
//
//                    if view.card == card {
//                        view.isUpsideDown = !view.isUpsideDown
//                    }
//
//                    if view.isUpsideDown && view.isDisabled {
//                        view.wasDisabled = true
//                        view.removeDisabledView()
//                    } else if !view.isUpsideDown && view.wasDisabled {
//                        view.wasDisabled = false
//                        view.addDisabledView()
//                    }
//                }
//                if let view = view as? SpecialCardView {
//                    if view.card == card {
//                        view.isUpsideDown = !view.isUpsideDown
//                    }
//                }
//            }
//        }
//        layoutIfNeeded()
//    }
//
//    func getTappedCard() -> CardView? {
//        for cardView in cardViews where cardView.tappedState == .tapped {
//            return cardView
//        }
//        return nil
//    }
//
//    func getAdditionalCardConstraints(forPlaceholderView placeholderView: UIView) {
//        var topConstraints: [Int: NSLayoutConstraint] = [:]
//        var leadingConstraints: [Int: NSLayoutConstraint] = [:]
//        for cardView in cardViews {
//            let topConstraint = cardView.topAnchor.constraint(equalTo: placeholderView.topAnchor)
//            let leadingConstraint = cardView.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor)
//            topConstraints.updateValue(topConstraint, forKey: cardView.tag)
//            leadingConstraints.updateValue(leadingConstraint, forKey: cardView.tag)
//        }
//        guard let player,
//              let activePlayer = delegate?.getActivePlayer()
//        else { return }
//        if player == activePlayer {
//            self.topConstraints = topConstraints
//            self.placeholderLeadingConstraints = leadingConstraints
//        }
//    }
//
//    func getSelectedCard() -> CardView? {
//        for cardView in cardViews where cardView.selectedState == .selected {
//            return cardView
//        }
//        return nil
//    }
//
//    func updateShouldBeDisabled(for card: NumberCardView,
//                                trumpSuit: CardSuit,
//                                hasFirstSuit: Bool,
//                                currentCardIsFirstSuit: Bool) {
//        guard let delegate else { fatalError("Delegate not setup for handView") }
//
//        if delegate.isPassingPhase() {
//            card.removeDisabledView()
//            return
//        } else {
//            if card.cardSuit == trumpSuit {
//                card.removeDisabledView()
//                return
//            }
//            if hasFirstSuit && currentCardIsFirstSuit {
//                card.removeDisabledView()
//                return
//            }
//            if hasFirstSuit && !currentCardIsFirstSuit {
//                card.addDisabledView()
//                return
//            }
//            if !hasFirstSuit {
//                card.removeDisabledView()
//                return
//            }
//        }
//    }
//}
