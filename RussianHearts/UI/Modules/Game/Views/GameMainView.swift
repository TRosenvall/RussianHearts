//
//  GameMainView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/20/23.
//

import UIKit

protocol GameMainViewDelegate: AnyObject {
    func getActivePlayer() -> PlayerModel

    func getPlayers() -> [PlayerModel]

    func endTurn(cardPlayed: Card?) -> EndTurnType

    func getPlayedCards() -> [Card]

    func routeToMainMenu()

    func routeToHighScores()

    func getPlayerIdForFirstPlayerThisPhase() -> Int

    func getTrump() -> CardSuit

    func getSuitPlayedFirst() -> CardSuit?
    
    func playerHasSuitInHand(_ player: PlayerModel, suit: CardSuit?) -> Bool
    
    func isSuit(for card: NumberCard, suit: CardSuit?) -> Bool

    func getNumberOfCardsForRound() -> Int

    func getWinningPlayers() -> [PlayerModel]

    func removeGame()

    func isPassingPhase() -> Bool

    func passesForward() -> Bool

    func getEndTurnType() -> EndTurnType
}

class GameMainView:
    UIView,
    MainView,
    PlayAreaViewDelegate,
    GameAlertViewDelegate
{

    // MARK: - Properties
    weak var delegate: GameMainViewDelegate?

    var moduleColor: UIColor

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

    lazy var navBarView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        return view
    }()

    lazy var blockerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        return view
    }()

    // Labels
    lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(label)

        return label
    }()

    // Buttons
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(button)

        button.addTarget(self,
                         action: #selector(backButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // CustomViews
    lazy var playAreaView: PlayAreaView? = self.getNewPlayArea()

    lazy var gameAlertView: GameAlertView = {
        let view = GameAlertView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        return view
    }()

    // MARK: - Lifecycle
    init(delegate: GameMainViewDelegate,
         moduleColor: UIColor) {
        self.delegate = delegate
        self.moduleColor = moduleColor
        super.init(frame: CGRect())

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func backButtonTapped() {
        // Nil for the back button presses
        gameAlertView.newAlert(for: nil)
    }

    // MARK: - Conformance: PlayAreaViewDelegate
    func getPlayer() -> PlayerModel {
        guard let delegate
        else { fatalError( "Delegate improperly configured" ) }

        return delegate.getActivePlayer()
    }

    func getPlayers() -> [PlayerModel] {
        if let delegate {
            return delegate.getPlayers()
        }
        return []
    }

    func endTurn(cardPlayed: Card) {
        let endTurnType = delegate?.endTurn(cardPlayed: cardPlayed)
        for subView in self.subviews where subView is PlayAreaView {
            subView.removeFromSuperview()
        }
        playAreaView = nil
        self.layoutIfNeeded()
        playAreaView = getNewPlayArea()
        setupPlayArea()
        updatePlayArea()

        guard let delegate else {
            fatalError( "Delegate not properly configured" )
        }

        if delegate.getActivePlayer().isHuman {
            gameAlertView.newAlert(for: endTurnType)
        } else {
            let endTurnType = delegate.getEndTurnType()
            runComputerActions(isBidding: endTurnType == .roundEnd)
        }
    }

    func getPlayedCards() -> [Card] {
        if let delegate {
            return delegate.getPlayedCards()
        }
        return []
    }

    func getPlayerIdForFirstPlayerThisPhase() -> Int {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getPlayerIdForFirstPlayerThisPhase()
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
    
    func playerHasSuitInHand(_ player: PlayerModel, suit: CardSuit?) -> Bool {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.playerHasSuitInHand(player, suit: suit)
    }
    
    func isSuit(for card: NumberCard, suit: CardSuit?) -> Bool {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.isSuit(for: card, suit: suit)
    }

    func getNumberOfCardsForRound() -> Int {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getNumberOfCardsForRound()
    }

    func flipCards() {
        playAreaView?.handView.flipCards()
    }

    func getWinningPlayers() -> [PlayerModel] {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getWinningPlayers()
    }

    func isPassingPhase() -> Bool {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.isPassingPhase()
    }

    func passesForward() -> Bool {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.passesForward()
    }

    // MARK: - Conformance: GameAreaViewDelegate
    func getActivePlayer() -> PlayerModel {
        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        return delegate.getActivePlayer()
    }

    func makeBlockerViewVisible() {
        blockerView.isHidden = false
    }

    func makeBlockerViewHidden() {
        blockerView.isHidden = true
        gameAlertView.isVisible = false
    }

    func shouldRouteBackToMainMenu() {
        delegate?.routeToMainMenu()
    }

    func shouldRouteToHighScores() {
        delegate?.routeToHighScores()
    }

    var biddingSetCount: Int = 0
    func biddingSet() {
        guard let playersCount = delegate?.getPlayers().count else { return }
        _ = delegate?.endTurn(cardPlayed: nil)
        for subView in self.subviews where subView is PlayAreaView {
            subView.removeFromSuperview()
        }
        playAreaView = nil
        self.layoutIfNeeded()
        playAreaView = getNewPlayArea()
        setupPlayArea()
        updatePlayArea()

        guard let delegate
        else { fatalError( "Delegate not configured" ) }
        let activePlayer = delegate.getActivePlayer()

        // This forces the .roundEnd New Round screen until bidding has finished.
        if biddingSetCount < playersCount - 1 {

            biddingSetCount += 1
            if activePlayer.isHuman {
                gameAlertView.newAlert(for: .roundEnd)
            } else {
                runComputerActions(isBidding: true)
            }
        } else {
            biddingSetCount = 0
            if activePlayer.isHuman {
                gameAlertView.newAlert(for: .turnEnd)
            } else {
                runComputerActions()
            }
        }
    }

    func removeGame() {
        delegate?.removeGame()
    }

    // MARK: - Conformance: MainView
    func setupViews() {
        // Constants
        let spacer: CGFloat = 22
        let borderWidth: CGFloat = 3
        let cornerRadius: CGFloat = self.frame.width/7

        // View
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white

        // Background Color View
        backgroundBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        // Figured these numbers out by guess and check, these should probably be formalized.
        backgroundBorderView.layer.borderColor = moduleColor.cgColor
        backgroundBorderView.layer.borderWidth = borderWidth
        backgroundBorderView.layer.cornerRadius = cornerRadius
        
        // Background Color View
        backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        backgroundColorView.backgroundColor = moduleColor
        backgroundColorView.alpha = 0.001

        // Play Area View
        setupPlayArea()

        // Nav Bar View
        navBarView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        navBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        navBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        navBarView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // Back Button
        backButton.topAnchor.constraint(equalTo: navBarView.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 3*spacer).isActive = true
        backButton.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
        backButton.setImage(UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate),
                            for: .normal)
        backButton.tintColor = moduleColor
        
        // Title Label
        titleLabel.topAnchor.constraint(equalTo: navBarView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
        titleLabel.text = "Game"
        titleLabel.textAlignment = .center
        titleLabel.textColor = moduleColor

        // Blocker View
        blockerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blockerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        blockerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        blockerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        blockerView.backgroundColor = .darkGray
        blockerView.alpha = 0.66
        blockerView.isHidden = true

        // Game Alert View
        gameAlertView.moduleColor = moduleColor
        gameAlertView.delegate = self
        gameAlertView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        gameAlertView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gameAlertView.heightAnchor.constraint(equalTo: self.heightAnchor,
                                              multiplier: 0.4).isActive = true
        gameAlertView.widthAnchor.constraint(equalTo: self.widthAnchor,
                                             multiplier: 0.75).isActive = true
    }

    // MARK: - Helpers
    func setupPlayArea() {
        playAreaView?.moduleColor = moduleColor
        playAreaView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        playAreaView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        playAreaView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        playAreaView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        playAreaView?.setupHandView()
        playAreaView?.layoutIfNeeded()
        playAreaView?.handView.flipCards()
    }

    func getNewPlayArea() -> PlayAreaView {
        let view = PlayAreaView()

        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(view, aboveSubview: backgroundBorderView)
        
        return view
    }

    func updatePlayArea() {
        let dispatchWorkItem = DispatchWorkItem {
            self.playAreaView?.setupPlayArea()
        }
        DispatchQueue.main.async {
            self.playAreaView?.setupCenteringView()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: dispatchWorkItem)
        self.playAreaView?.layoutIfNeeded()
    }

    func finalUpdates() {
        self.layoutIfNeeded()
        updatePlayArea()

        guard let delegate
        else {
            fatalError( "Delegate not configured" )
        }

        let isHuman = delegate.getActivePlayer().isHuman

        if isHuman {
            gameAlertView.newAlert(for: .roundEnd)
        } else {
            runComputerActions(isBidding: true)
        }
    }

    func runComputerActions(isBidding: Bool = false) {
        let player = getActivePlayer()

        guard let delegate
        else {
            fatalError("Delegate not found, module resolving screwed up")
        }

        print(isBidding)
        if isBidding {

            let players = delegate.getPlayers()
            let totalBidsForRound = delegate.getNumberOfCardsForRound()

            var totalBids = 0
            for player in players {
                if let activeBid = player.activeBid {
                    totalBids += activeBid.value
                }
            }

            let disallowedBid = totalBidsForRound - totalBids

            var currentBidAmount: Int? = nil
            if getActivePlayer() == getLastPlayer(players: players) {
                currentBidAmount = disallowedBid

                while currentBidAmount == disallowedBid {
                    currentBidAmount = Int.random(in: 0...getNumberOfCardsForRound() )
                }
            } else {
                currentBidAmount = Int.random(in: 0...getNumberOfCardsForRound())
            }

            guard let currentBidAmount
            else {
                fatalError( "Screwed up the computers bid" )
            }

            player.activeBid = Bid(value: currentBidAmount)
            biddingSet()
            return
        } else {
            var chosenCard: Card? = nil
            while chosenCard == nil {
                guard let tempCard = player.cards.randomElement()
                else { fatalError("Player has no cards") }

                if !tempCard.isDisabled {
                    chosenCard = tempCard
                }

                chosenCard?.tappedState = .tapped
            }
            
            guard let playAreaView
            else { fatalError("Play Area View Not configured properly.") }
            for cardView in playAreaView.handView.cardViews
            where cardView.tappedState == .tapped {
                if let cardView = cardView as? NumberCardView {
                    cardView.tappedState = .notTapped
                    cardView.cardTappedButtonTapped()
                }
                if let cardView = cardView as? SpecialCardView {
                    cardView.tappedState = .notTapped
                    cardView.cardTappedButtonTapped()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                playAreaView.playAreaButtonTapped()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    playAreaView.endTurnButtonTapped()
                }
            }
        }
    }

    func getLastPlayer(players: [PlayerModel]) -> PlayerModel {
        guard let delegate
        else {
            fatalError("Delegate not set")
        }

        // Get the first id and the total number of players playing
        let firstId = delegate.getPlayerIdForFirstPlayerThisPhase()
        let totalPlayers = players.count

        var lastId: Int = 0
        // If the firstId is greater than 1, then the last player will be 1 less than the current first id.
        if firstId > 1 {
            lastId = firstId - 1
        } else if firstId == 1 {
        // If the firstId is 1, then the last player to play will have an id of the total amount of players playing
            lastId = totalPlayers
        } else {
            fatalError("Player Ids should always be >= 1")
        }

        var lastPlayer: PlayerModel? = nil
        for player in players where player.id == lastId {
            lastPlayer = player
        }

        guard let lastPlayer else { fatalError("Last Player Not Found") }
        return lastPlayer
    }
}
