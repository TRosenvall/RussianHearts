//
//  playAreaView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/5/23.
//

import UIKit

protocol PlayAreaViewDelegate {
    func getPlayer() -> PlayerModel

    func getPlayers() -> [PlayerModel]

    func getPlayedCards() -> [Card]

    func endTurn(cardPlayed: Card)

    func getPlayerIdForFirstPlayerThisPhase() -> Int

    func getTrump() -> CardSuit

    func getSuitPlayedFirst() -> CardSuit?
    
    func playerHasSuitInHand(_ player: PlayerModel, suit: CardSuit) -> Bool
    
    func isSuit(for card: NumberCard, suit: CardSuit) -> Bool
}

// This view will be the full size of the containing view controller
class PlayAreaView: UIView, HandViewDelegate, PlayerInfoViewDelegate {

    // MARK: - Properties
    var delegate: PlayAreaViewDelegate?

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

    var cardPlaceholderViews: [UIView] = []
    var activePlayer: PlayerModel?

    var isSelected: Bool {
        return handView.isSelected
    }

    // MARK: - Views
    // Views
    lazy var playerInfoView: PlayerInfoView = {
        let view = PlayerInfoView()
        view.delegate = self
        view.activePlayer = getActivePlayer()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        return view
    }()

    lazy var centeringView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        return view
    }()

    lazy var bottomView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        return view
    }()

    // Buttons
    lazy var playAreaButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)

        button.addTarget(self,
                         action: #selector(playAreaButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var endTurnButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)

        button.addTarget(self,
                         action: #selector(endTurnButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // CustomViews
    lazy var handView: HandView = {
        let view = HandView()
        view.moduleColor = moduleColor
    
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        return view
    }()

    // MARK: - Lifecycle
    init() {
        print("Play Area View")
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func playAreaButtonTapped() {
        print("====")
        guard let cardView = handView.getTappedCard()
        else {
            print("No Card Selected")
            return
        }

        if let cardView = cardView as? NumberCardView {
            print("Card Selected")
            print("Card Suit: \(cardView.card.suit)")
            print("Card Value: \(cardView.card.value)")
        } else if let cardView = cardView as? SpecialCardView {
            print("Card Selected")
            print("Card Name: \(cardView.card.name)")
        }

        switch cardView.selectedState {
        case .selected: cardView.selectedState = .notSelected
        case .notSelected: cardView.selectedState = .selected
        }
        handView.updateSelected(cardView)

        if isSelected {
            endTurnButton.isEnabled = true
            endTurnButton.alpha = 1
        } else {
            endTurnButton.isEnabled = false
            endTurnButton.alpha = 0.33
        }
    }

    @objc func endTurnButtonTapped() {
        if let card = (handView.getTappedCard() as? NumberCardView)?.card {
            card.playedByPlayerWithId = activePlayer?.id
            delegate?.endTurn(cardPlayed: card)
        }
        if let card = (handView.getTappedCard() as? SpecialCardView)?.card {
            card.playedByPlayerWithId = activePlayer?.id
            delegate?.endTurn(cardPlayed: card)
        }
    }

    // MARK: - Conformance: HandViewDelegate
    func playAreaTapped() {
        playAreaButtonTapped()
    }

    func getActivePlayer() -> PlayerModel {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getPlayer()
    }

    func getPlayedCards() -> [Card] {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getPlayedCards()
    }

    func getPlayerIdForFirstPlayerThisPhase() -> Int {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getPlayerIdForFirstPlayerThisPhase()
    }

    func getPlayers() -> [PlayerModel] {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getPlayers()
    }

    func getTrump() -> CardSuit {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getTrump()
    }

    func getSuitPlayedFirst() -> CardSuit? {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getSuitPlayedFirst()
    }
    
    func playerHasSuitInHand(_ player: PlayerModel, suit: CardSuit) -> Bool {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.playerHasSuitInHand(player, suit: suit)
    }
    
    func isSuit(for card: NumberCard, suit: CardSuit) -> Bool {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.isSuit(for: card, suit: suit)
    }

    // MARK: - Helpers
    func setupViews() {
        // View
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white

        // Get the view added, we'll set the constrains down a little.
        let _ = centeringView
    
        // Play Area Button
        playAreaButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        playAreaButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        playAreaButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        playAreaButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        // Player Info View
        playerInfoView.setupViews()
        playerInfoView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                            constant: 44).isActive = true
        playerInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -2).isActive = true
        playerInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 2).isActive = true
        playerInfoView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        playerInfoView.delegate = self
        playerInfoView.moduleColor = .white
        playerInfoView.layer.borderWidth = 2
        playerInfoView.layer.borderColor = UIColor.black.cgColor

        // Bottom View
        // -100 was chosen to help remove the playAreaButton taps below the hand view.
        bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: self.bottomAnchor,
                                        constant: -100).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // End Turn Button
        endTurnButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        endTurnButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                               constant: 22).isActive = true
        endTurnButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -22).isActive = true
        endTurnButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        endTurnButton.setTitle("End Turn", for: .normal)
        endTurnButton.setTitleColor(moduleColor, for: .normal)
        endTurnButton.layer.borderColor = moduleColor.cgColor
        endTurnButton.layer.borderWidth = 2
        endTurnButton.layer.cornerRadius = 22
        endTurnButton.isEnabled = false
        endTurnButton.alpha = 0.33

        // Hand View
        handView.moduleColor = moduleColor
        handView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        handView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        handView.bottomAnchor.constraint(equalTo: endTurnButton.topAnchor,
                                         constant: -22).isActive = true
        // 0.175 is completely arbitrary, just looked alright.
        handView.heightAnchor.constraint(equalTo: self.heightAnchor,
                                         multiplier: 5/3 * 0.175).isActive = true
        handView.clipsToBounds = false
        handView.delegate = self
    }

    func setupHandView() {
        let player = delegate?.getPlayer()
        activePlayer = player
        handView.player = player
    }

    func setupCenteringView() {
        // Centering View
        centeringView.topAnchor.constraint(equalTo: playerInfoView.bottomAnchor).isActive = true
        centeringView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        centeringView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        centeringView.bottomAnchor.constraint(equalTo: handView.topAnchor).isActive = true

        layoutIfNeeded()
    }

    func setupPlayArea() {
        let cardRatio: CGFloat = 62.0/88.0
        let cardHeight: CGFloat = self.frame.height * 0.175
        let cardWidth: CGFloat = cardHeight * cardRatio
        let heightSpacer: CGFloat = (centeringView.frame.height - (2 * cardHeight))/3
        let widthSpacer: CGFloat = (centeringView.frame.width - (3 * cardWidth))/4

        guard let delegate else { return }
        let players: [PlayerModel] = delegate.getPlayers().sorted { $0.id < $1.id }

        for i in 0..<6 {

            var player: PlayerModel? = nil
            for j in 0..<players.count where i == j {
                player = players[i]
            }

            let widthNumber: CGFloat = CGFloat(i%3)

            // Card Location Views
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            centeringView.addSubview(view)

            view.heightAnchor.constraint(equalToConstant: cardHeight).isActive = true
            view.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
            if i > 2 {
                view.topAnchor.constraint(equalTo: centeringView.topAnchor,
                                          constant: 2*heightSpacer + cardHeight).isActive = true
            } else {
                view.topAnchor.constraint(equalTo: centeringView.topAnchor,
                                          constant: heightSpacer).isActive = true
            }
            view.leadingAnchor.constraint(equalTo: centeringView.leadingAnchor,
                                          constant: (widthNumber + 1)*widthSpacer + widthNumber*cardWidth).isActive = true

            view.layer.borderColor = moduleColor.cgColor
            view.layer.borderWidth = 3
            view.layer.cornerRadius = cardWidth/7
            if let player {
                view.tag = player.id
            }

            cardPlaceholderViews.append(view)

            layoutIfNeeded()

            // Player Name Text Label
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            centeringView.addSubview(label)

            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

            label.text = player?.name
            label.textAlignment = .center
            label.numberOfLines = 0
            label.minimumScaleFactor = 0.1
            label.adjustsFontSizeToFitWidth = true
        }
        layoutIfNeeded()

        for cardPlaceholderView in cardPlaceholderViews where cardPlaceholderView.tag == activePlayer?.id {
            handView.getAdditionalCardConstraints(forPlaceholderView: cardPlaceholderView)
        }

        layoutIfNeeded()
        let playedCards = delegate.getPlayedCards()
        for cardPlaceholderView in cardPlaceholderViews {
            for card in playedCards where card.playedByPlayerWithId == cardPlaceholderView.tag {
                var cardView: CardView?
                if let card = card as? NumberCard {
                    cardView = NumberCardView(card: card)
                }
                if let card = card as? SpecialCard {
                    cardView = SpecialCardView(card: card)
                }
                if let cardView {
                    cardView.translatesAutoresizingMaskIntoConstraints = false
                    self.addSubview(cardView)
                    cardView.topAnchor.constraint(equalTo: cardPlaceholderView.topAnchor).isActive = true
                    cardView.leadingAnchor.constraint(equalTo: cardPlaceholderView.leadingAnchor).isActive = true
                    cardView.trailingAnchor.constraint(equalTo: cardPlaceholderView.trailingAnchor).isActive = true
                    cardView.bottomAnchor.constraint(equalTo: cardPlaceholderView.bottomAnchor).isActive = true
                    cardView.layer.cornerRadius = cardWidth/7
                }
                layoutIfNeeded()
                cardView?.isUpsideDown = false
                layoutIfNeeded()
            }
        }
    }
}
