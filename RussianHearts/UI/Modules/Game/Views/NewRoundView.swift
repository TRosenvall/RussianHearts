//
//  NewRoundView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/10/23.
//

import UIKit

protocol NewRoundViewDelegate {
    func getActivePlayer() -> PlayerModel?

    func getPlayers() -> [PlayerModel]

    func newRoundContinueButtonTapped()

    func getNumberOfCardsForRound() -> Int

    func flipCards()

    func getPlayerIdForFirstPlayerThisPhase() -> Int
}

class NewRoundView: UIView {

    // MARK: - Properties
    var delegate: NewRoundViewDelegate?

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

    // MARK: - Views
    // Views
    lazy var setBidView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        return view
    }()

    lazy var newTurnView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        return view
    }()

    lazy var scoresUnderlineView: UIView = {
        let label = UIView()

        label.translatesAutoresizingMaskIntoConstraints = false
        newTurnView.addSubview(label)

        return label
    }()

    // Labels
    lazy var bidLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(label)

        return label
    }()

    lazy var bidAmountLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(label)

        return label
    }()

    lazy var scoresLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        newTurnView.addSubview(label)

        return label
    }()

    // Buttons
    lazy var setBidButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(button)

        button.addTarget(self,
                         action: #selector(setBidButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var lowerBidAmountButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(button)

        button.addTarget(self,
                         action: #selector(lowerBidAmountButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var raiseBidAmountButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(button)

        button.addTarget(self,
                         action: #selector(raiseBidAmountButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // Labels
    lazy var playerNameLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        newTurnView.addSubview(label)

        return label
    }()
    
    // Buttons
    lazy var newRoundContinueButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        newTurnView.addSubview(button)

        button.addTarget(self,
                         action: #selector(newRoundContinueButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    init(delegate: NewRoundViewDelegate,
         moduleColor: UIColor) {
        super.init(frame: CGRect())
        self.delegate = delegate
        self.moduleColor = moduleColor

        self.translatesAutoresizingMaskIntoConstraints = false

        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func setBidButtonTapped() {
        print("Button 1")

        guard let bidAmountText = bidAmountLabel.text,
              let currentBidAmount = Int(bidAmountText)
        else { fatalError("Bid Failed") }

        delegate?.getActivePlayer()?.activeBid = Bid(value: currentBidAmount)
        delegate?.newRoundContinueButtonTapped()
    }

    @objc func newRoundContinueButtonTapped() {
        print("Button 2")
        delegate?.flipCards()
        newTurnView.removeFromSuperview()
        setBidView.alpha = 1
        layoutIfNeeded()
    }

    @objc func lowerBidAmountButtonTapped() {
        print("Button 3")

        guard let bidAmountLabelText = bidAmountLabel.text,
              let amount = Int(bidAmountLabelText),
              let delegate = delegate
        else { return }

        let players = delegate.getPlayers()
        let totalBidsForRound = delegate.getNumberOfCardsForRound()

        var totalBids = 0
        for player in players {
            if let activeBid = player.activeBid {
                totalBids += activeBid.value
            }
        }

        let disallowedBid = totalBidsForRound - totalBids

        if amount > 0 {
            let loweredAmount = amount - 1
            bidAmountLabel.text = loweredAmount.description

            if delegate.getActivePlayer() == getLastPlayer(players: players) {
                if loweredAmount == disallowedBid {
                    setBidButton.isEnabled = false
                    setBidButton.alpha = 0.33
                } else {
                    setBidButton.isEnabled = true
                    setBidButton.alpha = 1
                }
            }
        }
    }

    @objc func raiseBidAmountButtonTapped() {
        print("Button 4")

        guard let delegate,
              let bidAmountLabelText = bidAmountLabel.text,
              let amount = Int(bidAmountLabelText)
        else { return }

        let players = delegate.getPlayers()
        let totalBidsForRound = delegate.getNumberOfCardsForRound()

        var totalBids = 0
        for player in players {
            if let activeBid = player.activeBid {
                totalBids += activeBid.value
            }
        }

        let disallowedBid = totalBidsForRound - totalBids

        if amount < delegate.getNumberOfCardsForRound() {
            let raisedAmount = amount + 1
            bidAmountLabel.text = raisedAmount.description

            let activePlayer = delegate.getActivePlayer()
            let lastPlayer = getLastPlayer(players: players)
            if activePlayer == lastPlayer {
                if raisedAmount == disallowedBid {
                    setBidButton.isEnabled = false
                    setBidButton.alpha = 0.33
                } else {
                    setBidButton.isEnabled = true
                    setBidButton.alpha = 1
                }
            }
        }
    }

    // MARK: - Helpers
    func setupViews() {
        // Self
        self.backgroundColor = .clear

        // Set Bid View
        setBidView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        setBidView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        setBidView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        setBidView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        setBidView.backgroundColor = .clear
        setBidView.alpha = 0

        // New Turn View
        newTurnView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        newTurnView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        newTurnView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        newTurnView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        newTurnView.backgroundColor = .clear

        // Scores Label
        scoresLabel.centerXAnchor.constraint(equalTo: playerNameLabel.centerXAnchor).isActive = true
        scoresLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        scoresLabel.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor,
                                         constant: 22).isActive = true
        scoresLabel.widthAnchor.constraint(equalTo: playerNameLabel.widthAnchor).isActive = true
        scoresLabel.text = "Scores"
        scoresLabel.textColor = moduleColor
        scoresLabel.textAlignment = .center

        // Scores Underline View
        scoresUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        scoresUnderlineView.topAnchor.constraint(equalTo: scoresLabel.bottomAnchor, constant: -1).isActive = true
        scoresUnderlineView.widthAnchor.constraint(equalTo: scoresLabel.widthAnchor).isActive = true
        scoresUnderlineView.centerXAnchor.constraint(equalTo: scoresLabel.centerXAnchor).isActive = true
        scoresUnderlineView.backgroundColor = moduleColor

        var playerNameLabelOffset: CGFloat = 0
        if let players = delegate?.getPlayers() {
            for player in players.sorted(by: { $0.id < $1.id }) {
                // Player Names
                let playerNameTextLabel = UILabel()

                playerNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
                newTurnView.addSubview(playerNameTextLabel)

                playerNameTextLabel.leadingAnchor.constraint(
                    equalTo: scoresUnderlineView.leadingAnchor,
                    constant: 8
                ).isActive = true
                playerNameTextLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
                playerNameTextLabel.trailingAnchor.constraint(
                    equalTo: playerNameLabel.trailingAnchor,
                    constant: -77
                ).isActive = true
                playerNameTextLabel.topAnchor.constraint(
                    equalTo: scoresUnderlineView.bottomAnchor,
                    constant: playerNameLabelOffset
                ).isActive = true
                
                playerNameTextLabel.textColor = moduleColor
                playerNameTextLabel.text = player.name

                // Player Scores
                let playerScoreTextLabel = UILabel()

                playerScoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
                newTurnView.addSubview(playerScoreTextLabel)

                playerScoreTextLabel.leadingAnchor.constraint(
                    equalTo: playerNameTextLabel.trailingAnchor,
                    constant: 11
                ).isActive = true
                playerScoreTextLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
                playerScoreTextLabel.trailingAnchor.constraint(
                    equalTo: scoresUnderlineView.trailingAnchor,
                    constant: -8
                ).isActive = true
                playerScoreTextLabel.topAnchor.constraint(
                    equalTo: scoresUnderlineView.bottomAnchor,
                    constant: playerNameLabelOffset
                ).isActive = true
                
                playerScoreTextLabel.textColor = moduleColor
                playerScoreTextLabel.text = player.scoreTotal.description
                playerScoreTextLabel.textAlignment = .right

                // Post
                playerNameLabelOffset += 22
            }
        }

        // Bid Label
        bidLabel.topAnchor.constraint(equalTo: setBidView.topAnchor,
                                             constant: 22).isActive = true
        bidLabel.leadingAnchor.constraint(equalTo: setBidView.leadingAnchor,
                                                 constant: 8).isActive = true
        bidLabel.trailingAnchor.constraint(equalTo: setBidView.trailingAnchor,
                                                  constant: -8).isActive = true
        bidLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        bidLabel.textColor = moduleColor
        bidLabel.text = "Set Bid"
        bidLabel.textAlignment = .center

        // Bid Amount Label
        bidAmountLabel.topAnchor.constraint(equalTo: bidLabel.bottomAnchor,
                                            constant: 8).isActive = true
        bidAmountLabel.centerXAnchor.constraint(equalTo: setBidView.centerXAnchor).isActive = true
        bidAmountLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
        bidAmountLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        bidAmountLabel.textAlignment = .center
        bidAmountLabel.text = 0.description
        bidAmountLabel.textColor = moduleColor

        // Lower Bid Amount Button
        lowerBidAmountButton.topAnchor.constraint(equalTo: bidAmountLabel.topAnchor).isActive = true
        lowerBidAmountButton.leadingAnchor.constraint(equalTo: setBidView.leadingAnchor,
                                                      constant: 11).isActive = true
        lowerBidAmountButton.trailingAnchor.constraint(equalTo: bidAmountLabel.leadingAnchor,
                                                       constant: -11).isActive = true
        lowerBidAmountButton.bottomAnchor.constraint(equalTo: bidAmountLabel.bottomAnchor).isActive = true
        lowerBidAmountButton.setTitle("", for: .normal)
        lowerBidAmountButton.setImage(
            UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        lowerBidAmountButton.tintColor = moduleColor

        // Raise Bid Amount Button
        raiseBidAmountButton.topAnchor.constraint(equalTo: bidAmountLabel.topAnchor).isActive = true
        raiseBidAmountButton.leadingAnchor.constraint(equalTo: bidAmountLabel.trailingAnchor,
                                                      constant: 11).isActive = true
        raiseBidAmountButton.trailingAnchor.constraint(equalTo: setBidView.trailingAnchor,
                                                       constant: -11).isActive = true
        raiseBidAmountButton.bottomAnchor.constraint(equalTo: bidAmountLabel.bottomAnchor).isActive = true
        raiseBidAmountButton.setTitle("", for: .normal)
        raiseBidAmountButton.setImage(
            UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        raiseBidAmountButton.tintColor = moduleColor

        // Set Bid Button
        setBidButton.bottomAnchor.constraint(equalTo: setBidView.bottomAnchor,
                                                      constant: -22).isActive = true
        setBidButton.leadingAnchor.constraint(equalTo: setBidView.leadingAnchor,
                                                       constant: 22).isActive = true
        setBidButton.trailingAnchor.constraint(equalTo: setBidView.trailingAnchor,
                                                        constant: -22).isActive = true
        setBidButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        setBidButton.setTitle("Set Bid", for: .normal)
        setBidButton.setTitle("Total bids cannot equal cards to play", for: .disabled)
        setBidButton.setTitleColor(moduleColor, for: .normal)
        setBidButton.layer.borderColor = moduleColor.cgColor
        setBidButton.layer.borderWidth = 2
        setBidButton.layer.cornerRadius = 22

        // Player Name Label
        playerNameLabel.topAnchor.constraint(equalTo: newTurnView.topAnchor,
                                             constant: 22).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: newTurnView.leadingAnchor,
                                                 constant: 8).isActive = true
        playerNameLabel.trailingAnchor.constraint(equalTo: newTurnView.trailingAnchor,
                                                  constant: -8).isActive = true
        playerNameLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        playerNameLabel.textColor = moduleColor
        playerNameLabel.text = delegate?.getActivePlayer()?.name
        playerNameLabel.textAlignment = .center

        // New Turn Continue Button
        newRoundContinueButton.bottomAnchor.constraint(equalTo: newTurnView.bottomAnchor,
                                                      constant: -22).isActive = true
        newRoundContinueButton.leadingAnchor.constraint(equalTo: newTurnView.leadingAnchor,
                                                       constant: 22).isActive = true
        newRoundContinueButton.trailingAnchor.constraint(equalTo: newTurnView.trailingAnchor,
                                                        constant: -22).isActive = true
        newRoundContinueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        newRoundContinueButton.setTitle("New Round", for: .normal)
        newRoundContinueButton.setTitleColor(moduleColor, for: .normal)
        newRoundContinueButton.layer.borderColor = moduleColor.cgColor
        newRoundContinueButton.layer.borderWidth = 2
        newRoundContinueButton.layer.cornerRadius = 22
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
