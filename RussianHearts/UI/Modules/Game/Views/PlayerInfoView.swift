//
//  PlayerInfoView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/21/23.
//

import UIKit

protocol PlayerInfoViewDelegate {
    func getActivePlayer() -> PlayerModel
    func getTrump() -> CardSuit
}

// This view will be the full size of the containing view controller
class PlayerInfoView: UIView {

    // MARK: - Properties
    var delegate: PlayerInfoViewDelegate?

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

    var activePlayer: PlayerModel?

    // MARK: - Views
    // Views
    lazy var trumpColorView: UIView = {
        let label = UIView()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    // Label
    lazy var playerNameLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    lazy var trumpLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    lazy var bidLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    lazy var currentBidLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    lazy var trickLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    lazy var currentTrickLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    // MARK: - Lifecycle
    init() {
        super.init(frame: CGRect())

        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    // MARK: - Helpers
    func setupViews() {
        // Pre-setup
        activePlayer = delegate?.getActivePlayer()

        // View
        self.backgroundColor = moduleColor

        // Player Name Label
        playerNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playerNameLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        playerNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.22).isActive = true
        playerNameLabel.text = activePlayer?.name
        playerNameLabel.textColor = .black

        trumpLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trumpLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        trumpLabel.leadingAnchor.constraint(equalTo: playerNameLabel.trailingAnchor, constant: 22).isActive = true
        trumpLabel.widthAnchor.constraint(equalToConstant: 55).isActive = true
        trumpLabel.text = "Trump: "
        trumpLabel.textColor = .black

        trumpColorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trumpColorView.leadingAnchor.constraint(equalTo: trumpLabel.trailingAnchor, constant: 8).isActive = true
        trumpColorView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        trumpColorView.widthAnchor.constraint(equalTo: trumpColorView.heightAnchor, multiplier: 0.687).isActive = true
        trumpColorView.backgroundColor = delegate?.getTrump().transformToColor()

        bidLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        bidLabel.leadingAnchor.constraint(equalTo: trumpColorView.trailingAnchor, constant: 11).isActive = true
        bidLabel.widthAnchor.constraint(equalToConstant: 33).isActive = true
        bidLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        bidLabel.text = "Bid: "
        bidLabel.textColor = .black

        currentBidLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        currentBidLabel.leadingAnchor.constraint(equalTo: bidLabel.trailingAnchor).isActive = true
        currentBidLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
        currentBidLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        currentBidLabel.text = activePlayer?.activeBid?.value.description
        currentBidLabel.textColor = .black

        trickLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trickLabel.leadingAnchor.constraint(equalTo: currentBidLabel.trailingAnchor, constant: 11).isActive = true
        trickLabel.widthAnchor.constraint(equalToConstant: 93.5).isActive = true
        trickLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        trickLabel.text = "Tricks Won: "
        trickLabel.textColor = .black

        currentTrickLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        currentTrickLabel.leadingAnchor.constraint(equalTo: trickLabel.trailingAnchor).isActive = true
        currentTrickLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
        currentTrickLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        currentTrickLabel.text = activePlayer?.score.description
        currentTrickLabel.textColor = .black

        self.layoutSubviews()
    }

    func updateView() {
        activePlayer = delegate?.getActivePlayer()

        playerNameLabel.text = activePlayer?.name
        currentBidLabel.text = activePlayer?.activeBid?.value.description

        self.layoutSubviews()
    }
}
