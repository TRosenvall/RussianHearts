////
////  NewTurnView.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 9/10/23.
////
//
//import UIKit
//
//protocol NewTurnViewDelegate {
//    func getActivePlayer() -> Player?
//
//    func getPlayers() -> [Player]
//
//    func newTurnContinueButtonTapped()
//
//    func flipCards()
//}
//
//class NewTurnView: UIView {
//    
//    // MARK: - Properties
//    var delegate: NewTurnViewDelegate?
//    
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
//    // MARK: - Views
//    // Views
//    lazy var scoresUnderlineView: UIView = {
//        let label = UIView()
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(label)
//
//        return label
//    }()
//
//    // Labels
//    lazy var playerNameLabel: UILabel = {
//        let label = UILabel()
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(label)
//
//        return label
//    }()
//
//    lazy var scoresLabel: UILabel = {
//        let label = UILabel()
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(label)
//
//        return label
//    }()
//
//    // Buttons
//    lazy var newTurnContinueButton: UIButton = {
//        let button = UIButton(type: .system)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(button)
//
//        button.addTarget(self,
//                         action: #selector(newTurnContinueButtonTapped),
//                         for: .touchUpInside)
//        return button
//    }()
//
//    // MARK: - Lifecycle
//    init(delegate: NewTurnViewDelegate,
//         moduleColor: UIColor) {
//        super.init(frame: CGRect())
//        self.delegate = delegate
//        self.moduleColor = moduleColor
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
//    @objc func newTurnContinueButtonTapped() {
//        delegate?.newTurnContinueButtonTapped()
//        delegate?.flipCards()
//    }
//
//    // MARK: - Helpers
//    func setupViews() {
//        // Self
//        self.backgroundColor = .clear
//
//        // Player Name Label
//        playerNameLabel.topAnchor.constraint(equalTo: self.topAnchor,
//                                             constant: 22).isActive = true
//        playerNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
//                                                 constant: 11).isActive = true
//        playerNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
//                                                  constant: -11).isActive = true
//        playerNameLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
//        playerNameLabel.textColor = moduleColor
//        playerNameLabel.text = delegate?.getActivePlayer()?.name
//        playerNameLabel.textAlignment = .center
//
//        // Scores Label
//        scoresLabel.centerXAnchor.constraint(equalTo: playerNameLabel.centerXAnchor).isActive = true
//        scoresLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
//        scoresLabel.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor,
//                                         constant: 22).isActive = true
//        scoresLabel.widthAnchor.constraint(equalTo: playerNameLabel.widthAnchor).isActive = true
//        scoresLabel.text = "Scores"
//        scoresLabel.textColor = moduleColor
//        scoresLabel.textAlignment = .center
//
//        // Scores Underline View
//        scoresUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
//        scoresUnderlineView.topAnchor.constraint(equalTo: scoresLabel.bottomAnchor, constant: -1).isActive = true
//        scoresUnderlineView.widthAnchor.constraint(equalTo: scoresLabel.widthAnchor).isActive = true
//        scoresUnderlineView.centerXAnchor.constraint(equalTo: scoresLabel.centerXAnchor).isActive = true
//        scoresUnderlineView.backgroundColor = moduleColor
//
//        var playerNameLabelOffset: CGFloat = 0
//        if let players = delegate?.getPlayers() {
//            for player in players.sorted(by: { $0.id < $1.id }) {
//                // Player Names
//                let playerNameTextLabel = UILabel()
//
//                playerNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
//                self.addSubview(playerNameTextLabel)
//
//                playerNameTextLabel.leadingAnchor.constraint(
//                    equalTo: scoresUnderlineView.leadingAnchor,
//                    constant: 8
//                ).isActive = true
//                playerNameTextLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
//                playerNameTextLabel.trailingAnchor.constraint(
//                    equalTo: playerNameLabel.trailingAnchor,
//                    constant: -77
//                ).isActive = true
//                playerNameTextLabel.topAnchor.constraint(
//                    equalTo: scoresUnderlineView.bottomAnchor,
//                    constant: playerNameLabelOffset
//                ).isActive = true
//                
//                playerNameTextLabel.textColor = moduleColor
//                playerNameTextLabel.text = player.name
//
//                // Player Scores
//                let playerScoreTextLabel = UILabel()
//
//                playerScoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
//                self.addSubview(playerScoreTextLabel)
//
//                playerScoreTextLabel.leadingAnchor.constraint(
//                    equalTo: playerNameTextLabel.trailingAnchor,
//                    constant: 11
//                ).isActive = true
//                playerScoreTextLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
//                playerScoreTextLabel.trailingAnchor.constraint(
//                    equalTo: scoresUnderlineView.trailingAnchor,
//                    constant: -8
//                ).isActive = true
//                playerScoreTextLabel.topAnchor.constraint(
//                    equalTo: scoresUnderlineView.bottomAnchor,
//                    constant: playerNameLabelOffset
//                ).isActive = true
//                
//                playerScoreTextLabel.textColor = moduleColor
//                playerScoreTextLabel.text = player.scoreTotal.description
//                playerScoreTextLabel.textAlignment = .right
//
//                // Post
//                playerNameLabelOffset += 22
//            }
//        }
//
//        // New Turn Continue Button
//        newTurnContinueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
//                                                      constant: -22).isActive = true
//        newTurnContinueButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,
//                                                       constant: 22).isActive = true
//        newTurnContinueButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
//                                                        constant: -22).isActive = true
//        newTurnContinueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        newTurnContinueButton.setTitle("New Turn", for: .normal)
//        newTurnContinueButton.setTitleColor(moduleColor, for: .normal)
//        newTurnContinueButton.layer.borderColor = moduleColor.cgColor
//        newTurnContinueButton.layer.borderWidth = 2
//        newTurnContinueButton.layer.cornerRadius = 22
//    }
//}
