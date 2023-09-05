//
//  GameViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/9/23.
//

import UIKit

class GameViewController: UIViewController, GameView {

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
    lazy var handView: HandView = {
        let view = HandView()
        view.moduleColor = moduleColor
    
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)

        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Actions
    @objc func backButtonTapped() {
        
    }

    // MARK: - Conformance: GameView

    // MARK: - Helper
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

        // Hand View
        handView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        handView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        handView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        // 0.175 is completely arbitrary.
        handView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.175).isActive = true
        handView.clipsToBounds = false
        handView.player = presenter!.getPlayer()
    }

}

//let numberCard = NumberCard(value: .eight, suit: .swords)
//let cardView = NumberCardView(card: numberCard)
//cardView.isUpsideDown = true
//cardView.translatesAutoresizingMaskIntoConstraints = false
//self.view.addSubview(cardView)
//cardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
//cardView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33).isActive = true
//cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
//cardView.widthAnchor.constraint(equalTo: cardView.heightAnchor,
//                                multiplier: cardView.cardRatio).isActive = true
//cardView.cornerRadius = 22

//class GameViewController: UIViewController {
//
//    // MARK: - Outlets
//
//    @IBOutlet var verticalStackView: UIStackView!
//    @IBOutlet var statusBarView: UIView!
//    @IBOutlet var playAreaView: UIView!
//    @IBOutlet var handView: UIView!
//    @IBOutlet var dimmerView: UIView!
//    @IBOutlet var nextTurnView: UIView!
//    @IBOutlet var nextTurnLabel: UILabel!
//    @IBOutlet var startTurnButton: UIButton!
//    @IBOutlet var newRoundView: UIView!
//    @IBOutlet var newRoundStackView: UIStackView!
//    @IBOutlet var bidLabel: UILabel!
//    @IBOutlet var decreaseBidButton: UIButton!
//    @IBOutlet var currentBidAmountLabel: UILabel!
//    @IBOutlet var increaseBidButton: UIButton!
//    @IBOutlet var startRoundButton: UIButton!
//    @IBOutlet var nextTurnButton: UIButton!
//
//    // MARK: - Properties
//
//    // Number of rounds in the game and the active round
//    var roundCount: Int {
//        return Game.activeGame!.rounds.count
//    }
//
//    var activeRound: RoundModel {
//        return Game.activeGame!.activeRound
//    }
//
//    // Number of phases in the round and the active phase
//    var phaseCount: Int {
//        return activeRound.phases.count
//    }
//
//    var activePhase: PhaseModel {
//        return activeRound.activePhase
//    }
//
//    // Number of turns in the phase and the active turn
//    var turnCount: Int {
//        return activePhase.turns.count
//    }
//
//    var activeTurn: TurnModel {
//        return activePhase.activeTurn
//    }
//
//    // The active player whose turn it is.
//    var activePlayer: PlayerModel {
//        return activeTurn.activePlayer
//    }
//
//    // MARK: - Lifecycle Functions
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        nextTurnLabel.text = "\(activePlayer.name) Bidding Phase"
//        dimmerView.isHidden = false
//
//        setupHandView()
//    }
//
//    // MARK: - Actions
//
//    @IBAction func startTurnButtonTapped(_ sender: Any) {
//        if activePhase.id == 0 {
//            newRoundView.isHidden = false
//            startRoundButton.setTitle("Place Bid", for: .normal)
//        } else {
//            newRoundView.isHidden = true
//            startRoundButton.setTitle("Start Round", for: .normal)
//        }
//
//        dimmerView.isHidden = true
//    }
//
//    @IBAction func decreaseBidButtonTapped(_ sender: Any) {
//        if let currValue = Int(currentBidAmountLabel.text!) {
//            setBidValueLabel(value: currValue - 1)
//        }
//    }
//
//    @IBAction func increaseBidButtonTapped(_ sender: Any) {
//        if let currValue = Int(currentBidAmountLabel.text!) {
//            setBidValueLabel(value: currValue + 1)
//        }
//    }
//
//    @IBAction func startRoundButtonTapped(_ sender: Any) {
//        Phase.nextTurn()
//        if activePhase.id == 0 {
//            nextTurnLabel.text = "\(activePlayer.name) Bidding Phase"
//        } else {
//            nextTurnLabel.text = "\(activePlayer.name) Turn \(activePhase.id)"
//        }
//        dimmerView.isHidden = false
//
//    }
//
//    @IBAction func nextTurnButtonTapped(_ sender: Any) {
//        if Game.endOfGame {
////            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
////            let controller: ScoreViewController = storyboard.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
////            self.present(controller, animated: true)
//        } else {
//            Phase.nextTurn()
//            nextTurnLabel.text = "\(activePlayer.name) Turn \(activePhase.id)"
//            dimmerView.isHidden = false
//        }
//    }
//
//    // MARK: - Helpers
//
//    func setBidValueLabel(value: Int) {
//        let maxValue = Game.activeGame!.activeRound.numberOfCardsToPlay
//        let minValue = 0
//
//        if value < minValue || value > maxValue {
//            return
//        }
//
//        currentBidAmountLabel.text = "\(value)"
//    }
//
//    func setupHandView() {
//        let totalCards: CGFloat = CGFloat( activePlayer.cards.count )
//        for i in 0..<Int(totalCards) {
//            let card = activePlayer.cards[i]
//            var cardView = UIView()
//
//            if let numberCard = card as? NumberCard {
//                cardView = NumberCardView(card: numberCard, height: handView.frame.height)
//            }
//            if let specialCard = card as? SpecialCard {
//                cardView = SpecialCardView(card: specialCard, height: handView.frame.height)
//            }
//
//            cardView.translatesAutoresizingMaskIntoConstraints = false
//            handView.addSubview(cardView)
//            cardView.topAnchor.constraint(equalTo: handView.topAnchor).isActive = true
//            cardView.bottomAnchor.constraint(equalTo: handView.bottomAnchor).isActive = true
//
//            let cardWidth: CGFloat = handView.frame.height * C.cardAspectRatio
//
//            cardView.widthAnchor.constraint(equalToConstant: handView.frame.height * C.cardAspectRatio ).isActive = true
//
//            let handWidth: CGFloat = handView.frame.width
//            let spacer: CGFloat = cardWidth * 0.2
//            let totalCardsLess1: CGFloat = totalCards - 1
//            let j: CGFloat = CGFloat(i)
//
//            let offsetPart1: CGFloat = totalCards * cardWidth
//            let offsetPart2: CGFloat = totalCardsLess1 * spacer
//            let offsetPart3: CGFloat = offsetPart1 + offsetPart2
//            let offsetPart4: CGFloat = offsetPart3 - handWidth
//            let offsetPart5: CGFloat = offsetPart4 / 2
//
//            var offset: CGFloat = 0
//            let offsetIsNeeded: Bool = offsetPart4 > 0
//            if offsetIsNeeded {
//                offset = offsetPart5 / (totalCards - 1)
//            }
//
//            let trueOffsetPart1: CGFloat = ( j - totalCards/2 ) * cardWidth
//            let trueOffsetPart2: CGFloat = ( j + 1/2 - totalCards/2 ) * spacer
//            let trueOffsetPart3: CGFloat = ( totalCardsLess1 - 2 * j ) * offset
//            let trueOffset: CGFloat = trueOffsetPart1 + trueOffsetPart2 + trueOffsetPart3
//
//            cardView.leadingAnchor.constraint(equalTo: handView.centerXAnchor, constant: trueOffset).isActive = true
//
//            let gestureRecognizer = UIGestureRecognizer.init(target: self, action: #selector(cardWasTapped(cardIndex:)) )
//            cardView.addGestureRecognizer(gestureRecognizer)
//        }
//    }
//
//    @objc func cardWasTapped(cardIndex: Int) {
//        
//    }
//}
