//
//  GameOverView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/11/23.
//

import UIKit

protocol GameOverViewDelegate {
    func getWinningPlayer() -> PlayerModel?

    func routeToHighScores()
}

class GameOverView: UIView {

    // MARK: - Properties
    var delegate: GameOverViewDelegate?

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
    // Labels
    lazy var winnerNameLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    lazy var bidsLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()

    // Buttons
    lazy var routeToHighScoresButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)

        button.addTarget(self,
                         action: #selector(routeToHighScoresButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    init(delegate: GameOverViewDelegate,
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
    @objc func routeToHighScoresButtonTapped() {
        delegate?.routeToHighScores()
    }

    // MARK: - Helpers
    func setupViews() {
        // Self
        self.backgroundColor = .clear

        // Winner Name Label
        winnerNameLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: 22).isActive = true
        winnerNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: 8).isActive = true
        winnerNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -8).isActive = true
        winnerNameLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        winnerNameLabel.textColor = moduleColor
        winnerNameLabel.text = "Winner: \(delegate?.getWinningPlayer()?.name ?? "")"
        winnerNameLabel.textAlignment = .center

        // Bids Label
        bidsLabel.topAnchor.constraint(equalTo: winnerNameLabel.topAnchor,
                                             constant: 22).isActive = true
        bidsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: 8).isActive = true
        bidsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -8).isActive = true
        bidsLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        bidsLabel.textColor = moduleColor
        bidsLabel.text = "Bids: \(delegate?.getWinningPlayer()?.score ?? 0)"
        bidsLabel.textAlignment = .center

        // New Turn Continue Button
        routeToHighScoresButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                      constant: -22).isActive = true
        routeToHighScoresButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                       constant: 22).isActive = true
        routeToHighScoresButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                        constant: -22).isActive = true
        routeToHighScoresButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        routeToHighScoresButton.setTitle("High Scores", for: .normal)
        routeToHighScoresButton.setTitleColor(moduleColor, for: .normal)
        routeToHighScoresButton.layer.borderColor = moduleColor.cgColor
        routeToHighScoresButton.layer.borderWidth = 2
        routeToHighScoresButton.layer.cornerRadius = 22
    }
}
