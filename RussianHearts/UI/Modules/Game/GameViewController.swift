////
////  GameViewController.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 6/9/23.
////
//
//import UIKit
//
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
