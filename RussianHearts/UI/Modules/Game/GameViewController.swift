//
//  GameViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/9/23.
//

import UIKit

class GameViewController:
    UIViewController,
    GameView,
    PlayAreaViewDelegate,
    GameAlertViewDelegate
{

    // MARK: - Properties
    var id: UUID = UUID()
    var presenter: GamePresenting?
    var moduleColor: UIColor = .systemPurple

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

    lazy var blockerView: UIView = {
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
        self.view.addSubview(view)
        
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        updatePlayArea()

        gameAlertView.newAlert(for: .roundEnd)
    }

    // MARK: - Actions
    @objc func backButtonTapped() {
        // Nil for the back button presses
        gameAlertView.newAlert(for: nil)
    }

    // MARK: - Conformance: PlayAreaViewDelegate
    func getPlayer() -> PlayerModel {
        presenter!.getPlayer()
    }

    func getPlayers() -> [PlayerModel] {
        presenter!.getPlayers()
    }

    func endTurn(cardPlayed: Card) {
        let endTurnType = presenter!.endTurn(cardPlayed: cardPlayed)
        for subView in self.view.subviews where subView is PlayAreaView {
            subView.removeFromSuperview()
        }
        playAreaView = nil
        self.view.layoutIfNeeded()
        playAreaView = getNewPlayArea()
        setupPlayArea()
        updatePlayArea()

        gameAlertView.newAlert(for: endTurnType)
    }

    // MARK: - Conformance: GameView

    // MARK: - Conformance: GameAlertViewDelegate
    func getActivePlayer() -> PlayerModel? {
        return presenter?.getPlayer()
    }

    func makeBlockerViewVisible() {
        blockerView.isHidden = false
    }

    func makeBlockerViewHidden() {
        blockerView.isHidden = true
        gameAlertView.isVisible = false
    }

    func shouldRouteBackToMainMenu() {
        presenter?.routeToMainMenu()
    }

    func shouldRouteToHighScores() {
        presenter?.routeToHighScores()
    }

    var biddingSetCount: Int = 0
    func biddingSet() {
        guard let playersCount = presenter?.getPlayers().count else { return }
        _ = presenter!.endTurn(cardPlayed: nil)
        for subView in self.view.subviews where subView is PlayAreaView {
            subView.removeFromSuperview()
        }
        playAreaView = nil
        self.view.layoutIfNeeded()
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

    // MARK: - Helpers
    func setupViews() {
        // Constants
        let spacer: CGFloat = 22
        let borderWidth: CGFloat = 3
        let cornerRadius: CGFloat = self.view.frame.width/7
        
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
        backgroundBorderView.layer.cornerRadius = cornerRadius
        
        // Background Color View
        backgroundColorView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        backgroundColorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        backgroundColorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        backgroundColorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        backgroundColorView.backgroundColor = moduleColor
        backgroundColorView.alpha = 0.001

        // Play Area View
        setupPlayArea()

        // Nav Bar View
        navBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
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
        blockerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blockerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        blockerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        blockerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blockerView.backgroundColor = .darkGray
        blockerView.alpha = 0.66
        blockerView.isHidden = true

        // Game Alert View
        gameAlertView.moduleColor = moduleColor
        gameAlertView.delegate = self
        gameAlertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        gameAlertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        gameAlertView.heightAnchor.constraint(equalTo: self.view.heightAnchor,
                                              multiplier: 0.33).isActive = true
        gameAlertView.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                             multiplier: 0.75).isActive = true
    }

    func getNewPlayArea() -> PlayAreaView {
        let view = PlayAreaView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(view, aboveSubview: backgroundBorderView)
        
        return view
    }

    func setupPlayArea() {
        playAreaView?.moduleColor = moduleColor
        playAreaView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        playAreaView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        playAreaView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        playAreaView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        playAreaView?.delegate = self
        playAreaView?.setupHandView()
        playAreaView?.layoutIfNeeded()
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
}
