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
    
    func playerHasSuitInHand(_ player: PlayerModel, suit: CardSuit) -> Bool
    
    func isSuit(for card: NumberCard, suit: CardSuit) -> Bool

    func getNumberOfCardsForRound() -> Int
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
        if let delegate {
            return delegate.getActivePlayer()
        }
        return PlayerModel(name: "", id: -1)
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

        gameAlertView.newAlert(for: endTurnType)
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

        if biddingSetCount < playersCount - 1 {
            gameAlertView.newAlert(for: .roundEnd)
            biddingSetCount += 1
        } else {
            gameAlertView.newAlert(for: .turnEnd)
            biddingSetCount = 0
        }
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

        gameAlertView.newAlert(for: .roundEnd)
    }
}
