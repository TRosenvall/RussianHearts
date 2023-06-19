//
//  GameViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/9/23.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var verticalStackView: UIStackView!
    @IBOutlet var statusBarView: UIView!
    @IBOutlet var playAreaView: UIView!
    @IBOutlet var handView: UIView!
    @IBOutlet var dimmerView: UIView!
    @IBOutlet var nextTurnView: UIView!
    @IBOutlet var nextTurnLabel: UILabel!
    @IBOutlet var startTurnButton: UIButton!
    @IBOutlet var newRoundView: UIView!
    @IBOutlet var newRoundStackView: UIStackView!
    @IBOutlet var bidLabel: UILabel!
    @IBOutlet var decreaseBidButton: UIButton!
    @IBOutlet var currentBidAmountLabel: UILabel!
    @IBOutlet var increaseBidButton: UIButton!
    @IBOutlet var startRoundButton: UIButton!
    @IBOutlet var nextTurnButton: UIButton!

    // MARK: - Properties

    // Number of rounds in the game and the active round
    var roundCount: Int {
        return Game.activeGame!.rounds.count
    }

    var activeRound: RoundModel {
        return Game.activeGame!.activeRound
    }

    // Number of phases in the round and the active phase
    var phaseCount: Int {
        return activeRound.phases.count
    }

    var activePhase: PhaseModel {
        return activeRound.activePhase
    }

    // Number of turns in the phase and the active turn
    var turnCount: Int {
        return activePhase.turns.count
    }

    var activeTurn: TurnModel {
        return activePhase.activeTurn
    }

    // The active player whose turn it is.
    var activePlayer: PlayerModel {
        return activeTurn.activePlayer
    }

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        nextTurnLabel.text = "\(activePlayer.name) Bidding Phase"
        dimmerView.isHidden = false
    }

    // MARK: - Actions

    @IBAction func startTurnButtonTapped(_ sender: Any) {
        if activePhase.id == 0 {
            newRoundView.isHidden = false
            startRoundButton.setTitle("Place Bid", for: .normal)
        } else {
            newRoundView.isHidden = true
            startRoundButton.setTitle("Start Round", for: .normal)
        }

        dimmerView.isHidden = true
    }

    @IBAction func decreaseBidButtonTapped(_ sender: Any) {
        if let currValue = Int(currentBidAmountLabel.text!) {
            setBidValueLabel(value: currValue - 1)
        }
    }

    @IBAction func increaseBidButtonTapped(_ sender: Any) {
        if let currValue = Int(currentBidAmountLabel.text!) {
            setBidValueLabel(value: currValue + 1)
        }
    }

    @IBAction func startRoundButtonTapped(_ sender: Any) {
        Phase.nextTurn()
        if activePhase.id == 0 {
            nextTurnLabel.text = "\(activePlayer.name) Bidding Phase"
        } else {
            nextTurnLabel.text = "\(activePlayer.name) Turn \(activePhase.id)"
        }
        dimmerView.isHidden = false

    }

    @IBAction func nextTurnButtonTapped(_ sender: Any) {
        if Game.endOfGame {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller: ScoreViewController = storyboard.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
            self.present(controller, animated: true)
        } else {
            Phase.nextTurn()
            nextTurnLabel.text = "\(activePlayer.name) Turn \(activePhase.id)"
            dimmerView.isHidden = false
        }
    }

    // MARK: - Helpers

    func setBidValueLabel(value: Int) {
        let maxValue = Game.activeGame!.activeRound.numberOfCardsToPlay
        let minValue = 0

        if value < minValue || value > maxValue {
            return
        }

        currentBidAmountLabel.text = "\(value)"
    }
}

