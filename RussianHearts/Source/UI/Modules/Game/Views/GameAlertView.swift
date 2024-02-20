////
////  GameAlertView.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 9/9/23.
////
//
//import UIKit
//
//protocol GameAlertViewDelegate {
//    var blockerView: UIView { get set }
//
//    func getActivePlayer() -> Player
//
//    func getPlayers() -> [Player]
//
//    func makeBlockerViewVisible()
//
//    func makeBlockerViewHidden()
//
//    func shouldRouteBackToMainMenu()
//
//    func shouldRouteToHighScores()
//
//    func biddingSet()
//
//    func getNumberOfCardsForRound() -> Int
//
//    func flipCards()
//
//    func getPlayerIdForFirstPlayerThisPhase() -> Int
//
//    func getWinningPlayers() -> [Player]
//
//    func removeGame()
//
//    func getLastPlayer(players: [Player]) -> Player
//}
//
//// This view will be the full size of the containing view controller
//class GameAlertView:
//    UIView,
//    BackButtonTappedViewDelegate,
//    NewTurnViewDelegate,
//    NewPhaseViewDelegate,
//    NewRoundViewDelegate,
//    GameOverViewDelegate
//{
//
//    // MARK: - Properties
//    var delegate: GameAlertViewDelegate?
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
//    var activeView: UIView? {
//        didSet {
//            if activeView != nil {
//                isVisible = true
//            } else {
//                isVisible = false
//            }
//        }
//    }
//
//    // MARK: - Views
//    // Views
//    lazy var backgroundBorderView: UIView = {
//        let view = UIView()
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//        
//        return view
//    }()
//
//    lazy var backgroundColorView: UIView = {
//        let view = UIView()
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        backgroundBorderView.addSubview(view)
//        
//        return view
//    }()
//
//    var _isVisible: Bool = false
//    var isVisible: Bool {
//        get {
//            return _isVisible
//        }
//        set {
//            if newValue {
//                self.alpha = 1
//            } else {
//                self.alpha = 0
//            }
//            _isVisible = newValue
//        }
//    }
//
//    // MARK: - Lifecycle
//    init() {
//        super.init(frame: CGRect())
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
//
//    // MARK: - Conformance: BackButtonTappedViewDelegate
//    func backButtonTapped() {
//        delegate?.shouldRouteBackToMainMenu()
//    }
//
//    func cancelButtonTapped() {
//        delegate?.makeBlockerViewHidden()
//    }
//
//    // MARK: - Conformance: EndTurnViewDelegate
//    func getActivePlayer() -> Player? {
//        return delegate?.getActivePlayer()
//    }
//    
//    func newTurnContinueButtonTapped() {
//        print("Continue Button Tapped")
//
//        delegate?.makeBlockerViewHidden()
//    }
//
//    // MARK: - Conformance: EndPhaseViewDelegate
//    func newPhaseContinueButtonTapped() {
//        print("Continue Button Tapped")
//
//        delegate?.makeBlockerViewHidden()
//    }
//
//    // MARK: - Conformance: EndRoundViewDelegate
//    func newRoundContinueButtonTapped() {
//        print("Continue Button Tapped")
//
//        delegate?.makeBlockerViewHidden()
//        delegate?.biddingSet()
//    }
//
//    func getPlayers() -> [Player] {
//        guard let delegate
//        else {
//            fatalError("Delegate not set")
//        }
//
//        return delegate.getPlayers()
//    }
//
//    func getNumberOfCardsForRound() -> Int {
//        guard let delegate
//        else {
//            fatalError("Delegate not set")
//        }
//
//        return delegate.getNumberOfCardsForRound()
//    }
//
//    func flipCards() {
//        delegate?.flipCards()
//    }
//
//    func getPlayerIdForFirstPlayerThisPhase() -> Int {
//        guard let delegate
//        else {
//            fatalError("Delegate not set")
//        }
//
//        return delegate.getPlayerIdForFirstPlayerThisPhase()
//    }
//
//    func removeGame() {
//        delegate?.removeGame()
//    }
//
//    func getLastPlayer(players: [Player]) -> Player {
//        guard let delegate
//        else {
//            fatalError( "Delegate not configured properly" )
//        }
//
//        return delegate.getLastPlayer(players: players)
//    }
//
//    // MARK: - Conformance: GameOverViewDelegate
//    func getWinningPlayers() -> [Player] {
//        guard let delegate else {
//            fatalError("No Delegate Set")
//        }
//
//        return delegate.getWinningPlayers()
//    }
//
//    func routeToHighScores() {
//        delegate?.shouldRouteToHighScores()
//    }
//
//    // MARK: - Helpers
//    func setupViews() {
//        let borderWidth: CGFloat = 3
//        let cornerRadius: CGFloat = 22
//
//        // View
//        self.backgroundColor = .white
//        self.layer.cornerRadius = 22
//
//        // Background Color View
//        backgroundBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        backgroundBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        backgroundBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//        backgroundBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//        // Figured these numbers out by guess and check, these should probably be formalized.
//        backgroundBorderView.layer.borderColor = moduleColor.cgColor
//        backgroundBorderView.layer.borderWidth = borderWidth
//        backgroundBorderView.layer.cornerRadius = cornerRadius
//        
//        // Background Color View
//        backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
//        backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
//        backgroundColorView.backgroundColor = moduleColor
//        backgroundColorView.alpha = 0.001
//
//        activeView = nil
//    }
//
//    func getBackButtonTappedView() -> BackButtonTappedView {
//        let view = BackButtonTappedView(delegate: self,
//                                        moduleColor: moduleColor)
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//
//        return view
//    }
//
//    func getNewTurnView() -> NewTurnView {
//        let view = NewTurnView(delegate: self,
//                               moduleColor: moduleColor)
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//
//        return view
//    }
//
//    func getNewPhaseView() -> NewPhaseView {
//        let view = NewPhaseView(delegate: self,
//                                moduleColor: moduleColor)
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//
//        return view
//    }
//
//    func getNewRoundView() -> NewRoundView {
//        let view = NewRoundView(delegate: self,
//                                moduleColor: moduleColor)
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//
//        return view
//    }
//
//    func getGameOverView() -> GameOverView {
//        let view = GameOverView(delegate: self,
//                                moduleColor: moduleColor)
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//
//        return view
//    }
//
//    func newAlert(for endTurnType: EndTurnType?) {
//        print("End Turn Type: \(String(describing: endTurnType))")
//
//        if let activeView {
//            activeView.removeFromSuperview()
//        }
//        activeView = nil
//        self.layoutIfNeeded()
//
//        if let endTurnType {
//            switch endTurnType {
//            case .turnEnd:
//                activeView = getNewTurnView()
//            case .phaseEnd:
//                activeView = getNewPhaseView()
//            case .roundEnd:
//                activeView = getNewRoundView()
//            case .gameEnd:
//                activeView = getGameOverView()
//            }
//        } else {
//            activeView = getBackButtonTappedView()
//        }
//
//        delegate?.makeBlockerViewVisible()
//
//        activeView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        activeView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        activeView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        activeView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        self.layoutIfNeeded()
//    }
//}
