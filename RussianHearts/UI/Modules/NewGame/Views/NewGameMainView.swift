//
//  NewGameMainView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/19/23.
//

import UIKit

protocol NewGameMainViewDelegate: AnyObject {
    func backButtonTapped()

    func startNewGame(with playerValues: [Int? : PlayerOptions?])
}

class NewGameMainView:
    UIView,
    MainView,
    PlayerSelectorDelegate
{

    // MARK: - Properties
    weak var delegate: NewGameMainViewDelegate?

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

    lazy var instructionView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        return view
    }()

    lazy var instructionUnderlineView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        instructionView.addSubview(view)

        return view
    }()

    // Labels
    lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(label)

        return label
    }()

    lazy var playerNameLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        instructionView.addSubview(label)

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

    lazy var startGameButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)

        button.addTarget(self,
                         action: #selector(startGameButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // UIImageView
    lazy var isHumanImageView: UIImageView = {
        let image = UIImageView()

        image.translatesAutoresizingMaskIntoConstraints = false
        instructionView.addSubview(image)

        return image
    }()

    lazy var isComputerImageView: UIImageView = {
        let image = UIImageView()

        image.translatesAutoresizingMaskIntoConstraints = false
        instructionView.addSubview(image)

        return image
    }()

    // Custom Components
    lazy var playerSelectors: [PlayerSelector] = {
        var selectors: [PlayerSelector] = []

        for i in 0..<6 {
            let playerSelector = PlayerSelector()

            playerSelector.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(playerSelector)

            playerSelector.tag = i
            playerSelector.delegate = self
            playerSelector.selectorColor = moduleColor

            selectors.append(playerSelector)
        }

        return selectors
    }()


    // MARK: - Lifecycle
    init(moduleColor: UIColor) {
        self.moduleColor = moduleColor
        super.init(frame: CGRect())

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func dismissFirstResponder() {
        self.endEditing(true)
    }
    
    @objc func backButtonTapped(sender: UIButton!) {
        delegate?.backButtonTapped()
    }

    @objc func startGameButtonTapped(sender: UIButton!) {
        var playerValues: [Int: PlayerOptions] = [:]
        for playerSelector in playerSelectors {
            let key = playerSelector.tag + 1
            let value = playerSelector.playerNameTextField.text
            let isHuman = playerSelector.isHuman
            if let value, value != "" {
                let options: PlayerOptions = (name: value, isHuman: isHuman)
                playerValues.updateValue(options, forKey: key)
            }
        }
        delegate?.startNewGame(with: playerValues)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFirstResponder))
        self.addGestureRecognizer(tapGesture)

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
        titleLabel.text = "New Game"
        titleLabel.textAlignment = .center
        titleLabel.textColor = moduleColor

        // Instruction View
        instructionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor,
                                             constant: spacer).isActive = true
        instructionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        instructionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        instructionView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Player Selectors
        for i in playerSelectors {
            if i.tag == 0 {
                i.topAnchor.constraint(equalTo: instructionView.bottomAnchor,
                                       constant: spacer).isActive = true
                i.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                           constant: spacer).isActive = true
                i.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                            constant: -spacer).isActive = true
                i.playerNameTextField.text = "Player 1"
                i.isHuman = true
            }

            for j in playerSelectors where j.tag == i.tag + 1 {
                if j.tag == 1 {
                    j.playerNameTextField.text = "Computer 1"
                    j.isHuman = false
                }

                j.topAnchor.constraint(equalTo: i.bottomAnchor,
                                       constant: spacer).isActive = true
                j.leadingAnchor.constraint(equalTo: i.leadingAnchor).isActive = true
                j.trailingAnchor.constraint(equalTo: i.trailingAnchor).isActive = true
            }
        }

        // Player Name Label
        playerNameLabel.topAnchor.constraint(equalTo: instructionView.topAnchor).isActive = true
        playerNameLabel.bottomAnchor.constraint(equalTo: instructionView.bottomAnchor).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: playerSelectors[0].underlineView.leadingAnchor).isActive = true
        playerNameLabel.trailingAnchor.constraint(equalTo: playerSelectors[0].underlineView.trailingAnchor).isActive = true
        playerNameLabel.text = "Players Names"
        playerNameLabel.textColor = moduleColor

        // Is Human Image View
        isHumanImageView.centerYAnchor.constraint(equalTo: playerNameLabel.centerYAnchor).isActive = true
        isHumanImageView.leadingAnchor.constraint(equalTo: playerSelectors[0].isHumanButton.leadingAnchor).isActive = true
        isHumanImageView.trailingAnchor.constraint(equalTo: playerSelectors[0].isHumanButton.trailingAnchor).isActive = true
        isHumanImageView.bottomAnchor.constraint(equalTo: instructionView.bottomAnchor,
                                                 constant: -4).isActive = true
        isHumanImageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
        isHumanImageView.tintColor = moduleColor

        // Is Computer Image View
        isComputerImageView.centerYAnchor.constraint(equalTo: playerNameLabel.centerYAnchor).isActive = true
        isComputerImageView.leadingAnchor.constraint(equalTo: playerSelectors[0].isComputerButton.leadingAnchor).isActive = true
        isComputerImageView.trailingAnchor.constraint(equalTo: playerSelectors[0].isComputerButton.trailingAnchor).isActive = true
        isComputerImageView.bottomAnchor.constraint(equalTo: instructionView.bottomAnchor,
                                                 constant: -4).isActive = true
        isComputerImageView.image = UIImage(systemName: "desktopcomputer")?.withRenderingMode(.alwaysTemplate)
        isComputerImageView.tintColor = moduleColor

        // Instruction Underline View
        instructionUnderlineView.leadingAnchor.constraint(equalTo: playerNameLabel.leadingAnchor).isActive = true
        instructionUnderlineView.trailingAnchor.constraint(equalTo: isComputerImageView.trailingAnchor).isActive = true
        instructionUnderlineView.bottomAnchor.constraint(equalTo: instructionView.bottomAnchor).isActive = true
        instructionUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        instructionUnderlineView.backgroundColor = moduleColor

        // Start Game Button
        startGameButton.leadingAnchor.constraint(equalTo: playerNameLabel.leadingAnchor).isActive = true
        startGameButton.trailingAnchor.constraint(equalTo: isComputerImageView.trailingAnchor).isActive = true
        startGameButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        startGameButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        startGameButton.setTitle("Start Game", for: .normal)
        startGameButton.setTitleColor(moduleColor, for: .normal)
        startGameButton.layer.borderColor = moduleColor.cgColor
        startGameButton.layer.borderWidth = 2
        startGameButton.layer.cornerRadius = 22

        for player in playerSelectors {
            player.updateState()
        }
    }

    // MARK: - Conformance: PlayerSelectorDelegate
    func isHumanButtonTapped(onTag tag: Int) {
        for player in playerSelectors where player.tag == tag {
            player.updateState()
        }
    }

    func isComputerButtonTapped(onTag tag: Int) {
        for player in playerSelectors where player.tag == tag {
            player.updateState()
        }
    }

    func updatePlayerEnable(onTag tag: Int) {
        for player in playerSelectors where player.tag == tag {
            player.updateState()
        }

        var playerIsEnabledCount: Int = 0
        for player in playerSelectors where player.isEnabled {
            playerIsEnabledCount += 1
        }
        if playerIsEnabledCount >= 2 {
            startGameButton.isEnabled = true
            startGameButton.alpha = 1
        } else {
            startGameButton.isEnabled = false
            startGameButton.alpha = 0.33
        }
    }

    // MARK: - Helpers
}
