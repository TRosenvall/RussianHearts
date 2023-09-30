//
//  MainMenuViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import UIKit

class MainMenuViewController: UIViewController, MainMenuView {

    // MARK: - Properties
    var id: UUID = UUID()
    var presenter: MainMenuPresenting?
    var moduleColor: UIColor = .systemPink

    var continueButtonShouldEnable: Bool {
        if let presenter {
            return presenter.shouldEnableContinueButton
        }
        return false
    }

    // MARK: - Views
    // Views
    lazy var backgroundBorderView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)

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
        self.view.addSubview(view)
        
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
    lazy var newGameButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)

        button.addTarget(self,
                         action: #selector(newGameButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var continueGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = continueButtonShouldEnable

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        button.addTarget(self,
                         action: #selector(continueGameButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var highScoresButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        button.addTarget(self,
                         action: #selector(highScoresButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var rulesButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        button.addTarget(self,
                         action: #selector(rulesButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var friendsButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        button.addTarget(self,
                         action: #selector(friendsButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        button.addTarget(self,
                         action: #selector(settingsButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }

    // MARK: - Actions
    @objc func newGameButtonTapped(sender: UIButton!) {
        presenter?.routeToNewGameModule()
    }

    @objc func continueGameButtonTapped(sender: UIButton!) {
        print("Continue Game Button Tapped")
    }

    @objc func highScoresButtonTapped(sender: UIButton!) {
        presenter?.routeToHighScoreModule()
    }

    @objc func rulesButtonTapped(sender: UIButton!) {
        print("Rules Button Tapped")
    }

    @objc func friendsButtonTapped(sender: UIButton!) {
        print("Friends Button Tapped")
    }

    @objc func settingsButtonTapped(sender: UIButton!) {
        print("Settings Button Tapped")
    }

    // MARK: - Conformance: LaunchView

    // MARK: - Helper
    func setupViews() {
        // Constants
        let spacer: CGFloat = 22
        let buttonHeight: CGFloat = (self.view.safeAreaLayoutGuide.layoutFrame.size.height - 4*spacer - 44)/3
        let buttonWidth: CGFloat = (self.view.safeAreaLayoutGuide.layoutFrame.size.width - 3*spacer)/2
        let borderWidth: CGFloat = 3
        let bigCornerRadius: CGFloat = self.view.frame.width/7
        let cornerRadius: CGFloat = 22

        // View
        self.view.backgroundColor = .white

        // Background Color View
        backgroundBorderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        backgroundBorderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        backgroundBorderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        backgroundBorderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        // Figured these numbers out by guess and check, these should probably be formalized.
        backgroundBorderView.layer.borderColor = moduleColor.cgColor
        backgroundBorderView.layer.borderWidth = borderWidth
        backgroundBorderView.layer.cornerRadius = bigCornerRadius

        // Background Color View
        backgroundColorView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        backgroundColorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        backgroundColorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        backgroundColorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        backgroundColorView.backgroundColor = moduleColor
        backgroundColorView.alpha = 0.001

        // Nav Bar View
        navBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navBarView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Title Label
        titleLabel.topAnchor.constraint(equalTo: navBarView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
        titleLabel.text = "Russian Hearts"
        titleLabel.textAlignment = .center
        titleLabel.textColor = moduleColor

        // New Game Button
        newGameButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor,
                                           constant: spacer).isActive = true
        newGameButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                               constant: spacer).isActive = true
        newGameButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        newGameButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        newGameButton.backgroundColor = .clear
        newGameButton.layer.borderWidth = borderWidth
        newGameButton.layer.borderColor = moduleColor.cgColor
        newGameButton.layer.cornerRadius = cornerRadius
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.setTitleColor(moduleColor, for: .normal)

        // Continue Game Button
        continueGameButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor,
                                           constant: spacer).isActive = true
        continueGameButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                               constant: 2*spacer + buttonWidth).isActive = true
        continueGameButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        continueGameButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        continueGameButton.backgroundColor = .clear
        continueGameButton.layer.borderWidth = borderWidth
        continueGameButton.layer.borderColor = moduleColor.cgColor
        continueGameButton.layer.cornerRadius = cornerRadius
        continueGameButton.setTitle("Continue Game", for: .normal)
        continueGameButton.setTitleColor(moduleColor, for: .normal)
        if !continueGameButton.isEnabled {
            continueGameButton.alpha = 0.33
        }

        // Replays Button
        highScoresButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor,
                                           constant: 2*spacer + buttonHeight).isActive = true
        highScoresButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                               constant: spacer).isActive = true
        highScoresButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        highScoresButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        highScoresButton.backgroundColor = .clear
        highScoresButton.layer.borderWidth = borderWidth
        highScoresButton.layer.borderColor = moduleColor.cgColor
        highScoresButton.layer.cornerRadius = cornerRadius
        highScoresButton.setTitle("High Scores", for: .normal)
        highScoresButton.setTitleColor(moduleColor, for: .normal)

        // Rules Button
        rulesButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor,
                                         constant: 2*spacer + buttonHeight).isActive = true
        rulesButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                             constant: 2*spacer + buttonWidth).isActive = true
        rulesButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        rulesButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        rulesButton.backgroundColor = .clear
        rulesButton.layer.borderWidth = borderWidth
        rulesButton.layer.borderColor = moduleColor.cgColor
        rulesButton.layer.cornerRadius = cornerRadius
        rulesButton.setTitle("Rules", for: .normal)
        rulesButton.setTitleColor(moduleColor, for: .normal)

        // Friends Button
        friendsButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor,
                                           constant: 3*spacer + 2*buttonHeight).isActive = true
        friendsButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                               constant: spacer).isActive = true
        friendsButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        friendsButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        friendsButton.backgroundColor = .clear
        friendsButton.layer.borderWidth = borderWidth
        friendsButton.layer.borderColor = moduleColor.cgColor
        friendsButton.layer.cornerRadius = cornerRadius
        friendsButton.setTitle("Friends", for: .normal)
        friendsButton.setTitleColor(moduleColor, for: .normal)

        // Settings Button
        settingsButton.topAnchor.constraint(equalTo: navBarView.bottomAnchor,
                                           constant: 3*spacer + 2*buttonHeight).isActive = true
        settingsButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                constant: 2*spacer + buttonWidth).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        settingsButton.backgroundColor = .clear
        settingsButton.layer.borderWidth = borderWidth
        settingsButton.layer.borderColor = moduleColor.cgColor
        settingsButton.layer.cornerRadius = cornerRadius
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(moduleColor, for: .normal)
    }
}
